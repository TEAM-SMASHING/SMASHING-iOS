//
//  GameSubmissionDTO.swift
//  SMASHING
//
//  Created by 홍준범 on 1/21/26.
//

import Foundation

// MARK: - GameSubmissionDetailResponse

struct GameSubmissionDetailDTO: Codable {
    let attemptNo: Int
    let submitter: SubmitterSummaryDTO
    let winner: SideSummaryDTO
    let loser: SideSummaryDTO
}

// MARK: - SubmitterSummary

struct SubmitterSummaryDTO: Codable {
    let userId: String
    let nickname: String
}

// MARK: - SideSummary

struct SideSummaryDTO: Codable {
    let userId: String
    let nickname: String
    let score: Int
}
