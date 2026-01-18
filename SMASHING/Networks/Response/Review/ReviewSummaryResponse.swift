//
//  ReviewSummaryResponse.swift
//  SMASHING
//
//  Created by 이승준 on 1/19/26.
//

import Foundation

struct ReviewSummaryResponse: Decodable {
    let ratingCounts: RatingCounts
    let tagCounts: TagCounts
}

struct RatingCounts: Decodable {
    let best: Int
    let good: Int
    let bad: Int
}

struct TagCounts: Decodable {
    let goodManner: Int
    let onTime: Int
    let fairPlay: Int
    let fastResponse: Int
}
