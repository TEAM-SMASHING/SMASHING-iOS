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
    case matchingUpdated
    case matchingRequestNotificationCreated
    case matchingAcceptNotificationCreated
    
    // 게임 관련
    case gameUpdated
    case gameResultSubmittedNotificationCreated
    case gameResultRejectedNotificationCreated
    
    // 리뷰 관련
    case reviewReceivedNotificationCreated
    
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

struct SSEMatchingReceivedPayload: Codable {
    let type: String
    let matchingId: String
    let sportId: Int64
    let receiverProfileId: String
    let requester: SSERequesterSummary
}

struct SSERequesterSummary: Codable {
    let userId: String
    let nickname: String
    let gender: String
    let tierCode: String
    let wins: Int
    let losses: Int
    let reviewCount: Int64
}

final class SSEService: NSObject {
    private var session: URLSession?
    private var eventSourceTask: URLSessionDataTask?
    
    private var buffer = Data()
    
    private let eventSubject = PassthroughSubject<SseEventType, Never>()
    
    var eventPublisher: AnyPublisher<SseEventType, Never> {
        return eventSubject.eraseToAnyPublisher()
    }
    
    func connect(accessToken: String) {
        // 1. URL 설정 (BaseTargetType의 baseURL 패턴 활용)
        guard let url = URL(string: Environment.baseURL + "/api/v1/sse/subscribe") else { return }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = Double.infinity // 연결 유지
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        // 2. 헤더 설정 (명세 준수)
        request.setValue("text/event-stream", forHTTPHeaderField: "Content-Type")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        // 3. Session 구성 및 Delegate 설정
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

extension SSEService: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
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
                eventSubject.send(.matchingUpdated)
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
        }
    }
}
