//
//  SportsExperienceType.swift
//  SMASHING
//
//  Created by 이승준 on 1/17/26.
//

import Foundation

enum ExperienceRange: String, CaseIterable, Codable {
    case lt3Months   = "LT_3_MONTHS"
    case lt6Months   = "LT_6_MONTHS"
    case lt1Year     = "LT_1_YEAR"
    case lt1_6Years  = "LT_1_6_YEARS"
    case gte2Years   = "GTE_2_YEARS"
}

extension ExperienceRange {
    var displayText: String {
        switch self {
        case .lt3Months:
            return "3개월 미만"
        case .lt6Months:
            return "3개월 이상 ~ 6개월 미만"
        case .lt1Year:
            return "6개월 이상 ~ 1년 미만"
        case .lt1_6Years:
            return "1년 이상 ~ 1년 6개월 미만"
        case .gte2Years:
            return "1년 6개월 이상"
        }
    }
}
