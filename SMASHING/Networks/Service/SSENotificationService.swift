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

import Foundation
import Combine
import Network

// [기존 SseEventType 코드는 동일하게 유지]

final class SSEService: NSObject {
    static let shared = SSEService()
    
    private var session: URLSession?
    private var eventSourceTask: URLSessionDataTask?
    private var buffer = Data()
    
    private var lastHeartbeat: Date?
    private var reconnectTimer: AnyCancellable?
    private var isIntentionallyDisconnected = false
    private var isReconnecting = false // 재연결 중인지 확인하는 플래그
    
    private let checkInterval: TimeInterval = 1.0 // 1초 간격
    
    private let eventSubject = PassthroughSubject<SseEventType, Never>()
    var eventPublisher: AnyPublisher<SseEventType, Never> {
        return eventSubject.eraseToAnyPublisher()
    }
    
    private override init() {
        super.init()
    }
    
    func start() {
        isIntentionallyDisconnected = false
        isReconnecting = false
        attemptConnection()
        startMonitoring()
    }
    
    private func attemptConnection() {
        guard let token = KeychainService.get(key: Environment.accessTokenKey) else {
            print("❌ [SSE] Keychain 토큰 없음")
            return
        }
        self.connect(accessToken: token)
    }
    
    private func connect(accessToken: String) {
        // 재시도 중일 때는 세션을 완전히 파괴(invalidate)하지 않고 Task만 교체합니다.
        eventSourceTask?.cancel()
        
        guard let url = URL(string: Environment.baseURL + "/api/v1/sse/subscribe") else { return }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = Double.infinity
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        request.setValue("text/event-stream", forHTTPHeaderField: "Content-Type")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        // 세션이 없거나 무효화된 경우에만 새로 생성
        if session == nil {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = Double.infinity
            configuration.timeoutIntervalForResource = Double.infinity
            session = URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
        }
        
        eventSourceTask = session?.dataTask(with: request)
        eventSourceTask?.resume()
        
        lastHeartbeat = Date()
        // print("🚀 [SSE] Connection Attempted: \(url.absoluteString)")
    }
    
    private func startMonitoring() {
        reconnectTimer?.cancel()
        reconnectTimer = Timer.publish(every: checkInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkConnection()
            }
    }
    
    private func checkConnection() {
        // 수동 종료 상태라면 체크하지 않음
        guard !isIntentionallyDisconnected else { return }
        
        let timeSinceLastHeartbeat = Date().timeIntervalSince(lastHeartbeat ?? Date.distantPast)
        
        // 연결이 끊겼거나(running이 아님) 하트비트가 1.5초 이상 지연된 경우
        if eventSourceTask?.state != .running || timeSinceLastHeartbeat > (checkInterval * 1.5) {
            if !isReconnecting {
                // print("⚠️ [SSE] Connection lost. Retrying every 1s...")
                isReconnecting = true
            }
            // Disconnect()를 호출하지 않고 바로 연결 시도 (세션 유지)
            attemptConnection()
        } else {
            // 연결이 정상적으로 복구되면 플래그 해제
            if isReconnecting {
                // print("✅ [SSE] Connection Restored")
                isReconnecting = false
            }
        }
    }
    
    func disconnect(isManual: Bool = true) {
        isIntentionallyDisconnected = isManual
        isReconnecting = false
        
        if isManual {
            reconnectTimer?.cancel()
        }
        
        eventSourceTask?.cancel()
        session?.invalidateAndCancel()
        session = nil // 세션 초기화
        buffer.removeAll()
        print("🛑 [SSE] Connection \(isManual ? "Manually" : "Automatically") Stopped")
    }
}

extension SSEService: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        lastHeartbeat = Date()
        
        guard let responseString = String(data: data, encoding: .utf8) else { return }
        
        let lines = responseString.components(separatedBy: "\n")
        var eventName: String?
        
        for line in lines {
            if line.hasPrefix("event:") {
                eventName = line.replacingOccurrences(of: "event:", with: "").trimmingCharacters(in: .whitespaces)
            } else if line.hasPrefix("data:"), let eventName = eventName {
                let rawData = line.replacingOccurrences(of: "data:", with: "").trimmingCharacters(in: .whitespaces)
                
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
            default: // ⚠️ [SSE] Unhandled Event: game.result.rejected.notification.created
                print("⚠️ [SSE] Unhandled Event: \(eventName)")
            }
        } catch {
            print("❌ [SSE] Decoding Error for \(eventName): \(error)")
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            if let error = error {
                let nsError = error as NSError
                
                // 기존 연결 취소에 의한 에러는 재시도 루프를 방지하기 위해 무시
                if nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorCancelled {
                    return
                }
                
                print("❌ [SSE] Connection Error: \(error.localizedDescription)")
                
                if !isIntentionallyDisconnected {
                    // 에러 발생 시 3초 후 재연결 시도
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                        guard let self = self, !self.isIntentionallyDisconnected else { return }
                        self.start()
                    }
                }
            }
        }
}
