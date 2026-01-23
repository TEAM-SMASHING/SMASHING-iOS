//
//  GameResultSubmittedNotificationCreatedPayload.swift
//  SMASHING
//
//  Created by 이승준 on 1/22/26.
//

import Foundation

struct SSEGameResultSubmittedNotificationCreatedPayload: Codable {
    let type: String
    let notificationId: String
    let notificationType: NotificationType
    let notificationCreatedAt: String
    let sportId: Int64
    let receiverProfileId: String
    let gameId: String
    let submissionId: String
    let reason: GameResultRejectReason
    let submitter: SSESimpleUserSummary
}

enum GameResultRejectReason: String, Codable {
    case scoreMismatch = "SCORE_MISMATCH"
    case winLoseReversed = "WIN_LOSE_REVERSED"
    case scoreAndWinLoseMismatch = "SCORE_AND_WIN_LOSE_MISMATCH"
    case gameNotPlayedYet = "GAME_NOT_PLAYED_YET"
}
