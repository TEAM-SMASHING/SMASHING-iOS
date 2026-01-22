//
//  SSENotificationService.swift
//  SMASHING
//
//  Created by 이승준 on 1/22/26.
//

import Foundation
import Combine

enum SseEventType: String, Codable {
    // 연결 관련
    case systemConnected = "system.connected"
    
    // 매칭 관련
    case matchingReceived = "matching.received"
    case matchingUpdated = "matching.updated"
    case matchingRequestNotificationCreated = "matching.request.notification.created"
    case matchingAcceptNotificationCreated = "matching.accept.notification.created"
    
    // 게임 관련
    case gameUpdated = "game.updated"
    case gameResultSubmittedNotificationCreated = "game.result.submitted.notification.created"
    case gameResultRejectedNotificationCreated = "game.result.rejected.notification.created"
    
    // 리뷰 관련
    case reviewReceivedNotificationCreated = "review.received.notification.created"
}

/// SSE를 통해 전달받는 공통 데이터 포맷
struct SSEEventPayload: Decodable {
    let type: SseEventType
    // 추가적인 데이터 필드가 있다면 여기에 정의하거나,
    // 상세 데이터는 JSONSerialization으로 처리할 수 있습니다.
}

final class SSEService: NSObject {
    private var session: URLSession?
    private var eventSourceTask: URLSessionDataTask?
    
    private let eventSubject = PassthroughSubject<SSEEventPayload, Never>()
    
    var eventPublisher: AnyPublisher<SSEEventPayload, Never> {
        return eventSubject.eraseToAnyPublisher()
    }
    
    func connect(accessToken: String) {
        // 1. URL 설정 (BaseTargetType의 baseURL 패턴 활용)
        guard let url = URL(string: Environment.baseURL + "/sse/connect") else { return }
        
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
        do {
            let payload = try JSONDecoder().decode(SSEEventPayload.self, from: data)
            if eventName == payload.type.rawValue {
                print("✅ [SSE] Received Event: \(eventName)")
                eventSubject.send(payload)
            } else {
                print("⚠️ [SSE] Event name mismatch: \(eventName) vs \(payload.type.rawValue)")
            }
        } catch {
            print("❌ [SSE] Decoding Error: \(error)")
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("❌ [SSE] Connection Error: \(error.localizedDescription)")
        }
    }
}
