//
//  SSEMatchingAcceptNotificationCreatedPayload.swift
//  SMASHING
//
//  Created by 이승준 on 1/22/26.
//

import Foundation

struct SSEMatchingAcceptNotificationCreatedPayload: Codable {
    let type: String
    let notificationId: String
    let notificationType: NotificationType
    let notificationCreatedAt: String
    let matchingId: String
    let sportId: Int
    let receiverProfileId: String
    let acceptor: SSESimpleUserSummary
}
