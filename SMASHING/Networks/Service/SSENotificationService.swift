//
//  SSENotificationService.swift
//  SMASHING
//
//  Created by 이승준 on 1/22/26.
//

import Foundation
import Combine

enum SseEventType: Codable {
    // 연결 관련
    case systemConnected
    
    // 매칭 관련
    case matchingReceived(SSEMatchingReceivedPayload)
    case matchingUpdated(SSEMatchingUpdatedPayload)
    case matchingRequestNotificationCreated(SSEMatchingRequestNotificationCreatedPayload)
    case matchingAcceptNotificationCreated(SSEMatchingAcceptNotificationCreatedPayload)
    
    // 게임 관련
    case gameUpdated(SSEGameUpdatedPayload)
    case gameResultSubmittedNotificationCreated(SSEGameResultSubmittedNotificationCreatedPayload)
    case gameResultRejectedNotificationCreated(SSEGameResultRejectedNotificationCreatedPayload)
    
    // 리뷰 관련
    case reviewReceivedNotificationCreated(SSEReviewReceivedNotificationCreatedPayload)
    
    // 매칭 결정
    case acceptMatching // API 없음
    
    var apiText: String {
        switch self {
        case .systemConnected: return "system.connected"
        case .matchingReceived: return "matching.received"
        case .matchingUpdated: return "matching.updated"
        case .matchingRequestNotificationCreated: return "matching.request.notification.created"
        case .matchingAcceptNotificationCreated: return "matching.accept.notification.created"
        case .gameUpdated: return "game.updated"
        case .gameResultSubmittedNotificationCreated: return "game.result.submitted.notification.created"
        case .gameResultRejectedNotificationCreated: return "game.result.rejected.notification.created"
        case .reviewReceivedNotificationCreated: return "review.received.notification.created"
        case .acceptMatching: return ""
        }
    }
    
    var displayText: String {
        switch self {
        case .matchingReceived, .matchingRequestNotificationCreated(_):
            return "누군가가 매칭을 신청했어요! 받은 요청 탭에서 확인해주세요."
        case .matchingAcceptNotificationCreated:
            return "누군가가 매칭을 수락했어요! 매칭 확정 탭에서 확인해주세요."
        case .acceptMatching:
            return "매칭을 수락했어요! 매칭 확정 탭에서 확인해주세요."
        default:
            return ""
        }
    }
}

final class SSEService {
    static let shared = SSEService()

    private var streamTask: Task<Void, Never>?
    private var healthCheckTask: Task<Void, Never>?
    private var isManualDisconnect = false
    private var retryDelay: TimeInterval = 1.0
    private let maxRetryDelay: TimeInterval = 30.0

    // 연결 상태 체크 설정
    private var lastEventTime: Date?
    private let checkInterval: TimeInterval = 60        // 1분마다 체크
    private let connectionTimeout: TimeInterval = 180   // 3분 동안 이벤트 없으면 재연결

    private let eventSubject = PassthroughSubject<SseEventType, Never>()
    var eventPublisher: AnyPublisher<SseEventType, Never> {
        eventSubject.eraseToAnyPublisher()
    }

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = .infinity
        config.timeoutIntervalForResource = .infinity
        return URLSession(configuration: config)
    }()

    private init() {}

    func start() {
        isManualDisconnect = false
        retryDelay = 1.0
        lastEventTime = Date()

        guard let token = KeychainService.get(key: Environment.accessTokenKey) else {
            print("❌ [SSE] 토큰 없음")
            return
        }
        connect(token: token)
        startHealthCheck(token: token)
    }

    private func startHealthCheck(token: String) {
        healthCheckTask?.cancel()

        healthCheckTask = Task { [weak self] in
            while !Task.isCancelled {
                do {
                    try await Task.sleep(nanoseconds: UInt64(self?.checkInterval ?? 60) * 1_000_000_000)

                    guard let self = self,
                          !self.isManualDisconnect,
                          let lastTime = self.lastEventTime else { continue }

                    let elapsed = Date().timeIntervalSince(lastTime)

                    if elapsed > self.connectionTimeout {
                        print("⚠️ [SSE] \(Int(elapsed))초 동안 이벤트 없음 - 재연결")
                        self.retryDelay = 1.0
                        self.connect(token: token)
                    } else {
                        print("😀 [SSE] 연결 상태 양호 (마지막 이벤트: \(Int(elapsed))초 전)")
                    }
                } catch {
                    break
                }
            }
        }
    }

    private func connect(token: String) {
        streamTask?.cancel()

        guard let url = URL(string: Environment.baseURL + "/api/v1/sse/subscribe") else {
            print("❌ [SSE] URL 생성 실패")
            return
        }

        var request = URLRequest(url: url)
        request.setValue("text/event-stream", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        print("🚀 [SSE] 연결 시도: \(url)")

        streamTask = Task { [weak self] in
            do {
                let (bytes, response) = try await session.bytes(for: request)

                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    print("❌ [SSE] 연결 실패: 잘못된 응답")
                    await self?.scheduleReconnect(token: token)
                    return
                }

                print("✅ [SSE] 스트림 연결됨")
                self?.retryDelay = 1.0  // 연결 성공 시 리셋

                var eventName: String?

                for try await line in bytes.lines {
                    if Task.isCancelled { break }

                    self?.lastEventTime = Date()  // 이벤트 수신 시간 업데이트

                    if line.hasPrefix("event:") {
                        eventName = line.replacingOccurrences(of: "event:", with: "").trimmingCharacters(in: .whitespaces)
                    } else if line.hasPrefix("data:"), let event = eventName {
                        let rawData = line.replacingOccurrences(of: "data:", with: "").trimmingCharacters(in: .whitespaces)
                        if !rawData.isEmpty, let jsonData = rawData.data(using: .utf8) {
                            self?.handleDecodedEvent(eventName: event, data: jsonData)
                        }
                        eventName = nil
                    }
                }

                // 스트림이 정상 종료된 경우 (서버가 연결을 끊음)
                if !Task.isCancelled {
                    print("⚠️ [SSE] 스트림 종료됨")
                    await self?.scheduleReconnect(token: token)
                }
            } catch {
                if !Task.isCancelled {
                    print("❌ [SSE] 연결 에러: \(error.localizedDescription)")
                    await self?.scheduleReconnect(token: token)
                }
            }
        }
    }

    private func scheduleReconnect(token: String) async {
        guard !isManualDisconnect else {
            print("🛑 [SSE] 수동 종료 상태 - 재연결 안 함")
            return
        }

        print("🔄 [SSE] \(retryDelay)초 후 재연결...")

        do {
            try await Task.sleep(nanoseconds: UInt64(retryDelay * 1_000_000_000))

            guard !isManualDisconnect else { return }

            retryDelay = min(retryDelay * 2, maxRetryDelay)
            connect(token: token)
        } catch {
            // Task가 취소됨
        }
    }

    func disconnect() {
        isManualDisconnect = true
        streamTask?.cancel()
        streamTask = nil
        healthCheckTask?.cancel()
        healthCheckTask = nil
        lastEventTime = nil
        print("🛑 [SSE] 연결 종료")
    }

    @MainActor
    private func handleDecodedEvent(eventName: String, data: Data) {
        let decoder = JSONDecoder()
        do {
            switch eventName {
            case "system.connected":
                // print("✅ [SSE] System Connected")
                eventSubject.send(.systemConnected)

            case "matching.received":
                let payload = try decoder.decode(SSEMatchingReceivedPayload.self, from: data)
                print("✅ [SSE] Matching Received: \(payload.matchingId)")
                eventSubject.send(.matchingReceived(payload))

            case "matching.updated":
                let payload = try decoder.decode(SSEMatchingUpdatedPayload.self, from: data)
                print("✅ [SSE] Matching Updated: \(payload.matchingId)")
                eventSubject.send(.matchingUpdated(payload))

            case "matching.request.notification.created":
                let payload = try decoder.decode(SSEMatchingRequestNotificationCreatedPayload.self, from: data)
                print("✅ [SSE] Matching Request Notification Created: \(payload.matchingId)")
                eventSubject.send(.matchingRequestNotificationCreated(payload))

            case "matching.accept.notification.created":
                let payload = try decoder.decode(SSEMatchingAcceptNotificationCreatedPayload.self, from: data)
                print("✅ [SSE] Matching Accept Notification Created: \(payload.matchingId)")
                eventSubject.send(.matchingAcceptNotificationCreated(payload))

            case "game.updated":
                let payload = try decoder.decode(SSEGameUpdatedPayload.self, from: data)
                print("✅ [SSE] Game Updated: \(payload.gameId)")
                eventSubject.send(.gameUpdated(payload))

            case "game.result.submitted.notification.created":
                let payload = try decoder.decode(SSEGameResultSubmittedNotificationCreatedPayload.self, from: data)
                print("✅ [SSE] Game Result Submitted Notification Created: \(payload.gameId)")
                eventSubject.send(.gameResultSubmittedNotificationCreated(payload))

            case "game.result.rejected.notification.created":
                let payload = try decoder.decode(SSEGameResultRejectedNotificationCreatedPayload.self, from: data)
                print("✅ [SSE] Game Result Rejected Notification Created: \(payload.gameId)")
                eventSubject.send(.gameResultRejectedNotificationCreated(payload))

            case "review.received.notification.created":
                let payload = try decoder.decode(
                    SSEReviewReceivedNotificationCreatedPayload.self,
                    from: data
                )
                print("✅ [SSE] Review Received Notification Created: \(payload.gameId)")
                eventSubject.send(.reviewReceivedNotificationCreated(payload))

            default:
                print("⚠️ [SSE] Unhandled Event: \(eventName)")
            }
        } catch {
            print("❌ [SSE] Decoding Error for \(eventName): \(error)")
        }
    }
}
