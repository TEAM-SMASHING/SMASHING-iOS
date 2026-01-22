//
//  SSEMatchingRequestNotificationCreatedPayload.swift
//  SMASHING
//
//  Created by 이승준 on 1/22/26.
//

import Foundation

struct SSEMatchingRequestNotificationCreatedPayload: Codable {
    let type: String
    let notificationId: String
    let notificationType: NotificationType
    let notificationCreatedAt: String
    let matchingId: String
    let sportId: Int64
    let receiverProfileId: String
    let requester: SSESimpleUserSummary
}
