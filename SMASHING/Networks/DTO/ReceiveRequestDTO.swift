//
//  ReceiveRequestDTO.swift
//  SMASHING
//
//  Created by JIN on 1/18/26.
//

import Foundation

// MARK: - CursorResponse

struct ReceiveRequestCursorResponseDTO: Codable {
    let snapshotAt: String
    let results: [ReceiveRequestResultDTO]
    let nextCursor: String?
    let hasNext: Bool
}

// MARK: - ReceivedMatchingSummary

struct ReceiveRequestResultDTO: Codable {
    let matchingID: String
    let createdAt: String
    let status: String
    let requester: RequesterSummaryDTO

    enum CodingKeys: String, CodingKey {
        case matchingID = "matchingId"
        case createdAt, status, requester
    }
}

// MARK: - RequesterSummary

struct RequesterSummaryDTO: Codable {
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
