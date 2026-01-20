//
//  RecentReviewResponse.swift
//  SMASHING
//
//  Created by 이승준 on 1/19/26.
//

import Foundation

struct RecentReviewResponse: Decodable {
    let snapshotAt: String
    let results: [RecentReviewResult]
    let nextCursor: String?
    let hasNext: Bool
}

struct RecentReviewResult: Decodable {
    let gameReviewId: String
    let opponentNickname: String
    let createdAt: String
    let content: String?
}
