//
//  NotificationCursorResponseDTO.swift
//  SMASHING
//
//  Created by 이승준 on 1/21/26.
//

import Foundation

struct NotificationCursorResponseDTO: Codable {
    let snapshotAt: String
    let results: [NotificationSummaryResponseDTO]
    let nextCursor: String?
    let hasNext: Bool
}

struct NotificationSummaryResponseDTO: Codable {
    let notificationId: String
    let type: NotificationType
    let title: String
    let content: String
    let linkUrl: String?
    var isRead: Bool
    let createdAt: String
    let senderProfileId: String
}

struct NotificationSportMatchDTO: Decodable {
    let receiverUserProfileId: String
    let notificationSportCode: String
    let isMatch: Bool
}

struct NotificationBaseResponseDTO: Codable {
    let status: String
    let statusCode: Int
    let message: String?
    let errorCode: String?
    let errorName: String?
    let timestamp: String
}
