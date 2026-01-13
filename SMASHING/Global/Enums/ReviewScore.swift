//
//  ReviewScore.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

import UIKit

enum ReviewScore: String, Codable {
    case bad = "별로에요"
    case good = "좋아요"
    case best = "최고에요"
    
    enum CodingKeys: String, CodingKey {
        case bad = "BAD"
        case good = "GOOD"
        case best = "BEST"
    }
    
    var imageLarge: UIImage {
        switch self {
        case .bad: return UIImage.icThumbsDownLg
        case .good: return UIImage.icThumbsUpLg
        case .best: return UIImage.icThumbsUpDoubleLg
        }
    }
    
    var imageSmall: UIImage {
        switch self {
        case .bad: return UIImage.icThumbsDown
        case .good: return UIImage.icThumbsUp
        case .best: return UIImage.icThumbsUpDouble
        }
    }
}
