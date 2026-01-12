//
//  SSEEventType.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

enum SSEEventType: String, Codable {
    case matchingReceived = "내가 요청 받음"
    case matchingUpdated = "상대가 요청을 수락/거절/삭제"
    case matchingRequestNotificationCreated = "매칭 요청 알림 생성"
    case matchingAcceptNotificationCreated = "매칭 수락 알림 생성"
    case gameUpdated = "게임 관련 변경 사항"
    case gameResultSubmittedNotificationCreated = "게임 결과 제출 알림 생성"
    case gameResultRejectedNotificationCreated = "게임 결과 거절 알림 생성"
    case reviewReceivedNotificationCreated = "리뷰 제출 알림 생성"
    
    enum CodingKeys: String, CodingKey {
        case matchingReceived = "MATCHING_RECEIVED"
        case matchingUpdated = "MATCHING_UPDATED"
        case matchingRequestNotificationCreated = "MATCHING_REQUEST_NOTIFICATION_CREATED"
        case matchingAcceptNotificationCreated = "MATCHING_ACCEPT_NOTIFICATION_CREATED"
        case gameUpdated = "GAME_UPDATED"
        case gameResultSubmittedNotificationCreated = "GAME_RESULT_SUBMITTED_NOTIFICATION_CREATED"
        case gameResultRejectedNotificationCreated = "GAME_RESULT_REJECTED_NOTIFICATION_CREATED"
        case reviewReceivedNotificationCreated = "REVIEW_RECEIVED_NOTIFICATION_CREATED"
    }
    
    var eventName: String {
        switch self {
        case .matchingReceived:
            "matching.received"
        case .matchingUpdated:
            "matching.updated"
        case .matchingRequestNotificationCreated:
            "matching.request.notification.created"
        case .matchingAcceptNotificationCreated:
            "matching.accept.notification.created"
        case .gameUpdated:
            "game.updated"
        case .gameResultSubmittedNotificationCreated:
            "game.result.submitted.notification.created"
        case .gameResultRejectedNotificationCreated:
            "game.result.rejected.notification.created"
        case .reviewReceivedNotificationCreated:
            "review.received.notification.created"
        }
    }
}
