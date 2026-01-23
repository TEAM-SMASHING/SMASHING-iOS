//
//  GameSubmissionRequestDTO.swift
//  SMASHING
//
//  Created by 홍준범 on 1/19/26.
//

import Foundation

struct GameFirstSubmissionRequestDTO: Encodable {
    let winnerUserId: String
    let loserUserId: String
    let scoreWinner: Int
    let scoreLoser: Int
    let review: ReviewRequestDTO
}

struct GameResubmissionRequestDTO: Encodable {
    let winnerUserId: String
    let loserUserId: String
    let scoreWinner: Int
    let scoreLoser: Int
}

struct ReviewRequestDTO: Encodable {
    let rating: String
    let content: String?
    let tags: [String]?
}

// MARK: - 확정 API용 DTO

/// 결과 확정 - 리뷰 필수
struct GameConfirmRequestDTO: Encodable {
    let review: ReviewRequestDTO
}

// MARK: - 반려 API용 DTO

/// 결과 반려 - 사유 필수
struct GameRejectRequestDTO: Encodable {
    let reason: String?
}

