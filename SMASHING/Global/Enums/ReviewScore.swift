//
//  ReviewScore.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

enum ReviewScore: String, Codable {
    case bad = "별로에요"
    case good = "좋아요"
    case best = "최고에요"
    
    enum CodingKeys: String, CodingKey {
        case bad = "BAD"
        case good = "GOOD"
        case best = "BEST"
    }
}
