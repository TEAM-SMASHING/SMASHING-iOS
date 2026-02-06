//
//  SseEventType.swift
//  SMASHING
//
//  Created by 이승준 on 2/6/26.
//

import Foundation

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

extension SseEventType {
    static func decode(name: String, data: Data, decoder: JSONDecoder) throws -> SseEventType? {
        switch name {
        case "system.connected":
            return .systemConnected
            
        case "matching.received":
            let payload = try decoder.decode(SSEMatchingReceivedPayload.self, from: data)
            return .matchingReceived(payload)
            
        case "matching.updated":
            let payload = try decoder.decode(SSEMatchingUpdatedPayload.self, from: data)
            return .matchingUpdated(payload)
            
        case "matching.request.notification.created":
            let payload = try decoder.decode(SSEMatchingRequestNotificationCreatedPayload.self, from: data)
            return .matchingRequestNotificationCreated(payload)
            
        case "matching.accept.notification.created":
            let payload = try decoder.decode(SSEMatchingAcceptNotificationCreatedPayload.self, from: data)
            return .matchingAcceptNotificationCreated(payload)
            
        case "game.updated":
            let payload = try decoder.decode(SSEGameUpdatedPayload.self, from: data)
            return .gameUpdated(payload)
            
        case "game.result.submitted.notification.created":
            let payload = try decoder.decode(SSEGameResultSubmittedNotificationCreatedPayload.self, from: data)
            return .gameResultSubmittedNotificationCreated(payload)
            
        case "game.result.rejected.notification.created":
            let payload = try decoder.decode(SSEGameResultRejectedNotificationCreatedPayload.self, from: data)
            return .gameResultRejectedNotificationCreated(payload)
            
        case "review.received.notification.created":
            let payload = try decoder.decode(SSEReviewReceivedNotificationCreatedPayload.self, from: data)
            return .reviewReceivedNotificationCreated(payload)
            
        default:
            return nil
        }
    }
}
