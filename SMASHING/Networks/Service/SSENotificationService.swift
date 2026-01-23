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
    case gameResultRejectedNotificationCreated(SSEGameResultSubmittedNotificationCreatedPayload)
    
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

import Foundation
import Combine

// [기존 SseEventType 코드는 동일하게 유지]

final class SSEService: NSObject {
    static let shared = SSEService()
    
    private var session: URLSession?
    private var eventSourceTask: URLSessionDataTask?
    private var buffer = Data()
    
    // 재연결 및 상태 관리를 위한 프로퍼티
    private var lastHeartbeat: Date?
    private var reconnectTimer: AnyCancellable?
    private var isIntentionallyDisconnected = false
    private let checkInterval: TimeInterval = 30.0 // 30초마다 상태 확인
    
    private let eventSubject = PassthroughSubject<SseEventType, Never>()
    var eventPublisher: AnyPublisher<SseEventType, Never> {
        return eventSubject.eraseToAnyPublisher()
    }
    
    private override init() {
        super.init()
    }
    
    func start() {
        isIntentionallyDisconnected = false
        
        guard let token = KeychainService.get(key: Environment.accessTokenKey) else {
            print("❌ [SSE] Keychain에 토큰이 없어 연결을 시작할 수 없습니다.")
            return
        }
        
        self.connect(accessToken: token)
        self.startMonitoring() // 감시 타이머 시작
    }
    
    private func connect(accessToken: String) {
        disconnect(isManual: false)
        
        guard let url = URL(string: Environment.baseURL + "/api/v1/sse/subscribe") else { return }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = Double.infinity
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        request.setValue("text/event-stream", forHTTPHeaderField: "Content-Type")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let configuration = URLSessionConfiguration.default
        // 중요: timeoutIntervalForResource를 매우 길게 설정하거나 유연하게 관리해야 합니다.
        configuration.timeoutIntervalForRequest = Double.infinity
        configuration.timeoutIntervalForResource = Double.infinity
        
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
        eventSourceTask = session?.dataTask(with: request)
        eventSourceTask?.resume()
        
        lastHeartbeat = Date() // 연결 시점 초기화
        print("🚀 [SSE] Connection Started: \(url.absoluteString)")
    }
    
    /// 주기적으로 연결 상태를 확인하는 타이머
    private func startMonitoring() {
        reconnectTimer?.cancel()
        reconnectTimer = Timer.publish(every: checkInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkConnection()
            }
    }
    
    private func checkConnection() {
        guard !isIntentionallyDisconnected else { return }
        
        // 마지막 수신 후 일정 시간이 지났거나 태스크가 중단된 경우 재연결
        let timeSinceLastHeartbeat = Date().timeIntervalSince(lastHeartbeat ?? Date.distantPast)
        
        // 1분(interval * 2) 동안 소식이 없거나 task가 비활성 상태면 재연결
        if timeSinceLastHeartbeat > (checkInterval * 2) || eventSourceTask?.state != .running {
            print("⚠️ [SSE] Connection lost or heartbeat timeout. Reconnecting...")
            self.start()
        }
    }
    
    func disconnect(isManual: Bool = true) {
        isIntentionallyDisconnected = isManual
        if isManual {
            reconnectTimer?.cancel()
        }
        
        eventSourceTask?.cancel()
        session?.invalidateAndCancel()
        buffer.removeAll()
        print("🛑 [SSE] Connection Disconnected (Manual: \(isManual))")
    }
}

// MARK: - URLSessionDataDelegate
extension SSEService: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        // 데이터를 수신할 때마다 하트비트 업데이트
        lastHeartbeat = Date()
        
        guard let responseString = String(data: data, encoding: .utf8) else { return }
        
        let lines = responseString.components(separatedBy: "\n")
        var eventName: String?
        
        for line in lines {
            if line.hasPrefix("event:") {
                eventName = line.replacingOccurrences(of: "event:", with: "").trimmingCharacters(in: .whitespaces)
            } else if line.hasPrefix("data:"), let eventName = eventName {
                let rawData = line.replacingOccurrences(of: "data:", with: "").trimmingCharacters(in: .whitespaces)
                
                // 빈 데이터(Keep-alive용)가 아닐 때만 처리
                if !rawData.isEmpty, let jsonData = rawData.data(using: .utf8) {
                    handleDecodedEvent(eventName: eventName, data: jsonData)
                }
            }
        }
    }
    
    private func handleDecodedEvent(eventName: String, data: Data) {
        let decoder = JSONDecoder()
        do {
            switch eventName {
            case "system.connected":
                print("✅ [SSE] System Connected")
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
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            let nsError = error as NSError
            
            // 1. 사용자가 의도적으로 끊었거나(cancelled), 재연결을 위해 기존 태스크를 취소한 경우 무시
            if nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorCancelled {
                print("ℹ️ [SSE] Connection cancelled as intended or for reconnection.")
                return
            }
            
            print("❌ [SSE] Connection Error: \(error.localizedDescription)")
            
            // 2. 진짜 에러(네트워크 끊김 등)인 경우에만 재시도 예약
            if !isIntentionallyDisconnected {
                // 기존 타이머나 중복 실행을 방지하기 위해 딜레이 후 실행
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
                    guard let self = self, !self.isIntentionallyDisconnected else { return }
                    print("🔄 [SSE] Retrying connection after error...")
                    self.start()
                }
            }
        }
    }
}
