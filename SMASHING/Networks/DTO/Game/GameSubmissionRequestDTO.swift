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
