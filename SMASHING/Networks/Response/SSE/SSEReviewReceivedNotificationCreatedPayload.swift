//
//  SSEReviewReceivedNotificationCreatedPayload.swift
//  SMASHING
//
//  Created by 이승준 on 1/22/26.
//

import Foundation

struct SSEReviewReceivedNotificationCreatedPayload: Codable {
    let type: String
    let notificationId: String
    let notificationType: NotificationType
    let notificationCreatedAt: String
    let sportId: Int64
    let receiverProfileId: String
    let gameId: String
    let reviewId: String
    let reviewer: SSESimpleUserSummary
}
