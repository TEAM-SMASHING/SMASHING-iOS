//
//  MatchingConfirmedDTO.swift
//  SMASHING
//
//  Created by Claude on 1/17/26.
//

import Foundation

// MARK: - CursorResponse 

struct MatchingConfirmedCursorResponseDTO: Codable {
    let snapshotAt: String
    let results: [MatchingConfirmedGameDTO]
    let nextCursor: String?
    let hasNext: Bool
}

// MARK: - PendingResultAcceptedGameSummary

struct MatchingConfirmedGameDTO: Codable {
    let gameID: String
    let resultStatus: String
    let createdAt: String
    let opponent: OpponentSummaryDTO
    let submitAvailableAt: String
    let remainingSeconds: Int
    let isSubmitLocked: Bool

    enum CodingKeys: String, CodingKey {
        case gameID = "gameId"
        case resultStatus, createdAt, opponent
        case submitAvailableAt, remainingSeconds, isSubmitLocked
    }
}

// MARK: - OpponentSummary

struct OpponentSummaryDTO: Codable {
    let userID: String
    let nickname: String
    let openchatUrl: String?
    let gender: String
    let tierCode: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname, openchatUrl, gender
        case tierCode
    }
}
