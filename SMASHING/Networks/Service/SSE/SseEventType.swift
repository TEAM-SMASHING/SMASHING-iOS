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
