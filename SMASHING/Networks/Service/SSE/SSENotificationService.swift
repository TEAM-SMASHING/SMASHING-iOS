//
//  SSENotificationService.swift
//  SMASHING
//
//  Created by 이승준 on 1/22/26.
//

import Foundation
import Combine

actor SSEService {
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

        healthCheckTask = Task {
            while !Task.isCancelled {
                do {
                    try await Task.sleep(nanoseconds: UInt64(checkInterval) * 1_000_000_000)

                    guard !self.isManualDisconnect,
                          let lastTime = self.lastEventTime else { continue }

                    let elapsed = Date().timeIntervalSince(lastTime)

                    if elapsed > self.connectionTimeout {
                        print("⚠️ [SSE] \(Int(elapsed))초 동안 이벤트 없음 - 재연결")
                        self.resetRetryDelay()
                        if let freshToken = await KeychainService.get(key: Environment.accessTokenKey) {
                            self.connect(token: freshToken)
                        }
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

        streamTask = Task {
            do {
                let (bytes, response) = try await session.bytes(for: request)

                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    print("❌ [SSE] 연결 실패: 잘못된 응답")
                    await scheduleReconnect(token: token)
                    return
                }

                print("✅ [SSE] 스트림 연결됨")
                resetRetryDelay()  // 연결 성공 시 리셋

                var eventName: String?

                for try await line in bytes.lines {
                    if Task.isCancelled { break }

                    updateLastEventTime()  // 이벤트 수신 시간 업데이트

                    if line.hasPrefix("event:") {
                        eventName = line.replacingOccurrences(of: "event:", with: "").trimmingCharacters(in: .whitespaces)
                    } else if line.hasPrefix("data:"), let event = eventName {
                        let rawData = line.replacingOccurrences(of: "data:", with: "").trimmingCharacters(in: .whitespaces)
                        if !rawData.isEmpty, let jsonData = rawData.data(using: .utf8) {
                            handleDecodedEvent(eventName: event, data: jsonData)
                        }
                        eventName = nil
                    }
                }

                // 스트림이 정상 종료된 경우 (서버가 연결을 끊음)
                if !Task.isCancelled {
                    print("⚠️ [SSE] 스트림 종료됨")
                    await scheduleReconnect(token: token)
                }
            } catch {
                if !Task.isCancelled {
                    print("❌ [SSE] 연결 에러: \(error.localizedDescription)")
                    await scheduleReconnect(token: token)
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

    private func resetRetryDelay() {
        retryDelay = 1.0
    }

    private func updateLastEventTime() {
        lastEventTime = Date()
    }

    private func handleDecodedEvent(eventName: String, data: Data) {
        let decoder = JSONDecoder()
        do {
            switch eventName {
            case "system.connected":
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
                    from: data)
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
