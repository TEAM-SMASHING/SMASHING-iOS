//
//  SentRequestResultDTO.swift
//  SMASHING
//
//  Created by JIN on 1/17/26.
//

import Foundation

// MARK: - CursorResponse (페이지네이션 응답)

struct SentRequestCursorResponseDTO: Codable {
    let snapshotAt: String
    let results: [SentRequestResultDTO]
    let nextCursor: String?
    let hasNext: Bool
}

// MARK: - SentMatchingSummaryResponse

struct SentRequestResultDTO: Codable {
    let matchingID: String
    let createdAt: String
    let status: String
    let receiver: SentRequestReceiverDTO

    enum CodingKeys: String, CodingKey {
        case matchingID = "matchingId"
        case createdAt, status, receiver
    }
}

// MARK: - ReceiverSummary

struct SentRequestReceiverDTO: Codable {
    let userID: String
    let nickname: String
    let gender: String
    let reviewCount: Int
    let tierCode: String
    let wins: Int
    let losses: Int

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname, gender, reviewCount
        case tierCode, wins, losses
    }
}
