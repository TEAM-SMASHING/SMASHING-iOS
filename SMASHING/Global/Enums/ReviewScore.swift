//
//  ReviewScore.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

enum ReviewScore: String, Codable {
    case bad = "BAD"
    case good = "GOOD"
    case best = "BEST"

    var displayText: String {
        switch self {
        case .bad: return "별로에요"
        case .good: return "좋아요"
        case .best: return "최고에요"
        }
    }
}
