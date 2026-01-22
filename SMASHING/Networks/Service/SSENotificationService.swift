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
        }
    }
    
    var displayText: String {
        switch self {
        case .matchingReceived:
            return "누군가가 매칭을 신청했어요! 받은 요청 탭에서 확인해주세요."
        case .matchingAcceptNotificationCreated:
            return "누군가가 매칭을 수락했어요! 매칭 확정 탭에서 확인해주세요."
        default:
            return ""
        }
    }
}

import Foundation
import Combine

// [기존 SseEventType 코드는 동일하게 유지]

final class SSEService: NSObject {
    // 1. 싱글톤 인스턴스 생성
    static let shared = SSEService()
    
    private var session: URLSession?
    private var eventSourceTask: URLSessionDataTask?
    private var buffer = Data()
    
    // Combine을 위한 Subject
    private let eventSubject = PassthroughSubject<SseEventType, Never>()
    
    // 외부에서 구독할 Publisher
    var eventPublisher: AnyPublisher<SseEventType, Never> {
        return eventSubject.eraseToAnyPublisher()
    }
    
    // 1. private init으로 외부 생성을 방지
    private override init() {
        super.init()
    }
    
    /// 2. Keychain에서 토큰을 가져와 SSE 연결을 시작하는 함수
    func start() {
        // Keychain에서 "accessToken"을 가져오는 로직 (본인의 Keychain 유틸리티에 맞춰 수정하세요)
        // 예: KeychainHelper.standard.read(service: "access-token", account: "smashing")
        guard let token = KeychainService.get(key: Environment.accessTokenKey) else {
            print("❌ [SSE] Keychain에 토큰이 없어 연결을 시작할 수 없습니다.")
            return
        }
        
        self.connect(accessToken: token)
    }
    
    private func connect(accessToken: String) {
        // 이미 연결되어 있다면 해제 후 재연결
        disconnect()
        
        guard let url = URL(string: Environment.baseURL + "/api/v1/sse/subscribe") else { return }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = Double.infinity
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        request.setValue("text/event-stream", forHTTPHeaderField: "Content-Type")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = Double.infinity
        configuration.timeoutIntervalForResource = Double.infinity
        
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
        eventSourceTask = session?.dataTask(with: request)
        eventSourceTask?.resume()
        
        print("🚀 [SSE] Connection Started: \(url.absoluteString)")
    }
    
    func disconnect() {
        eventSourceTask?.cancel()
        session?.invalidateAndCancel()
        buffer.removeAll()
        print("🛑 [SSE] Connection Disconnected")
    }
}

// MARK: - URLSessionDataDelegate
extension SSEService: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        // SSE 데이터는 조각나서 올 수 있으므로 버퍼를 활용하거나 개별 처리가 필요합니다.
        guard let responseString = String(data: data, encoding: .utf8) else { return }
        
        let lines = responseString.components(separatedBy: "\n")
        var eventName: String?
        
        for line in lines {
            if line.hasPrefix("event:") {
                eventName = line.replacingOccurrences(of: "event:", with: "").trimmingCharacters(in: .whitespaces)
            } else if line.hasPrefix("data:"), let eventName = eventName {
                let rawData = line.replacingOccurrences(of: "data:", with: "").trimmingCharacters(in: .whitespaces)
                
                if let jsonData = rawData.data(using: .utf8) {
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
            print("❌ [SSE] Connection Error: \(error.localizedDescription)")
            // 필요 시 재연결 로직 추가 가능
        }
    }
}

//final class SSEService: NSObject {
//    private var session: URLSession?
//    private var eventSourceTask: URLSessionDataTask?
//    
//    private var buffer = Data()
//    
//    private let eventSubject = PassthroughSubject<SseEventType, Never>()
//    
//    var eventPublisher: AnyPublisher<SseEventType, Never> {
//        return eventSubject.eraseToAnyPublisher()
//    }
//    
//    func connect(accessToken: String) {
//        guard let url = URL(string: Environment.baseURL + "/api/v1/sse/subscribe") else { return }
//        
//        var request = URLRequest(url: url)
//        request.timeoutInterval = Double.infinity
//        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
//        
//        request.setValue("text/event-stream", forHTTPHeaderField: "Content-Type")
//        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
//        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
//        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//        
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = Double.infinity
//        configuration.timeoutIntervalForResource = Double.infinity
//        
//        session = URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
//        eventSourceTask = session?.dataTask(with: request)
//        eventSourceTask?.resume()
//        
//        print("🚀 [SSE] Connection Started: \(url.absoluteString)")
//    }
//    
//    func disconnect() {
//        eventSourceTask?.cancel()
//        session?.invalidateAndCancel()
//        buffer.removeAll()
//        print("🛑 [SSE] Connection Disconnected")
//    }
//}
//
//extension SSEService: URLSessionDataDelegate {
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//        guard let responseString = String(data: data, encoding: .utf8) else { return }
//        
//        let lines = responseString.components(separatedBy: "\n")
//        var eventName: String?
//        
//        for line in lines {
//            if line.hasPrefix("event:") {
//                eventName = line.replacingOccurrences(of: "event:", with: "").trimmingCharacters(in: .whitespaces)
//            } else if line.hasPrefix("data:"), let eventName = eventName {
//                let rawData = line.replacingOccurrences(of: "data:", with: "").trimmingCharacters(in: .whitespaces)
//                
//                if let jsonData = rawData.data(using: .utf8) {
//                    handleDecodedEvent(eventName: eventName, data: jsonData)
//                }
//            }
//        }
//    }
//    
//    private func handleDecodedEvent(eventName: String, data: Data) {
//        let decoder = JSONDecoder()
//        do {
//            switch eventName {
//            case "system.connected":
//                print("✅ [SSE] System Connected")
//                eventSubject.send(.systemConnected)
//
//            case "matching.received":
//                let payload = try decoder.decode(SSEMatchingReceivedPayload.self, from: data)
//                print("✅ [SSE] Matching Received: \(payload.matchingId)")
//                eventSubject.send(.matchingReceived(payload))
//            
//            case "matching.updated":
//                let payload = try decoder.decode(SSEMatchingUpdatedPayload.self, from: data)
//                print("✅ [SSE] Matching Updated: \(payload.matchingId)")
//                eventSubject.send(.matchingUpdated(payload))
//                
//            case "matching.request.notification.created":
//                let payload = try decoder.decode(SSEMatchingRequestNotificationCreatedPayload.self, from: data)
//                print("✅ [SSE] Matching Request Notification Created: \(payload.matchingId)")
//                eventSubject.send(.matchingRequestNotificationCreated(payload))
//                
//            case "matching.accept.notification.created":
//                let payload = try decoder.decode(SSEMatchingAcceptNotificationCreatedPayload.self, from: data)
//                print("✅ [SSE] Matching Accept Notification Created: \(payload.matchingId)")
//                eventSubject.send(.matchingAcceptNotificationCreated(payload))
//                
//            case "game.updated":
//                let payload = try decoder.decode(SSEGameUpdatedPayload.self, from: data)
//                print("✅ [SSE] Game Updated: \(payload.gameId)")
//                eventSubject.send(.gameUpdated(payload))
//            
//            case "game.result.submitted.notification.created":
//                let payload = try decoder.decode(SSEGameResultSubmittedNotificationCreatedPayload.self, from: data)
//                print("✅ [SSE] Game Result Submitted Notification Created: \(payload.gameId)")
//                eventSubject.send(.gameResultSubmittedNotificationCreated(payload))
//            
//            case "review.received.notification.created":
//                let payload = try decoder.decode(
//                    SSEReviewReceivedNotificationCreatedPayload.self,
//                    from: data
//                )
//                print("✅ [SSE] Review Received Notification Created: \(payload.gameId)")
//                eventSubject.send(.reviewReceivedNotificationCreated(payload))
//                
//            default:
//                print("⚠️ [SSE] Unhandled Event: \(eventName)")
//            }
//        } catch {
//            print("❌ [SSE] Decoding Error for \(eventName): \(error)")
//        }
//    }
//    
//    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//        if let error = error {
//            print("❌ [SSE] Connection Error: \(error.localizedDescription)")
//        }
//    }
//}
