//
//  MatchingSearchDTO.swift
//  SMASHING
//
//  Created by JIN on 1/20/26.
//

import Foundation

// MARK: - Response

struct MatchingSearchViewUserDTO: Codable {
    let snapshotAt: String
    let results: [MatchingSearchUserProfileDTO]
    let nextCursor: String?
    let hasNext: Bool
}

// MARK: - MatchingSearchProfileCell

struct MatchingSearchUserProfileDTO: Codable {
    let userID: String
    let nickname: String
    let gender: Gender
    let tierCode: String
    let wins: Int
    let losses: Int
    let reviews: Int

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname, gender, tierCode, wins, losses, reviews
    }
}
