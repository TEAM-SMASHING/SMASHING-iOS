//
//  ReviewScore.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

import UIKit

enum ReviewScore: String, Codable {
    case bad = "BAD"
    case good = "GOOD"
    case best = "BEST"

    var displayText: String {
        switch self {
        case .bad: return "별로예요"
        case .good: return "좋아요"
        case .best: return "최고예요"
        }
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
