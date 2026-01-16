//
//  Tier.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//


import UIKit

enum Tier: Codable, Equatable {
    case iron
    case bronze3
    case bronze2
    case bronze1
    case silver3
    case silver2
    case silver1
    case gold3
    case gold2
    case gold1
    case platinum3
    case platinum2
    case platinum1
    case diamond3
    case diamond2
    case diamond1
    case challenger

    enum CodingKeys: String, CodingKey {
        case iron = "IRON"
        case bronze3 = "BRONZE_3"
        case bronze2 = "BRONZE_2"
        case bronze1 = "BRONZE_1"
        case silver3 = "SILVER_3"
        case silver2 = "SILVER_2"
        case silver1 = "SILVER_1"
        case gold3 = "GOLD_3"
        case gold2 = "GOLD_2"
        case gold1 = "GOLD_1"
        case platinum3 = "PLATINUM_3"
        case platinum2 = "PLATINUM_2"
        case platinum1 = "PLATINUM_1"
        case diamond3 = "DIAMOND_3"
        case diamond2 = "DIAMOND_2"
        case diamond1 = "DIAMOND_1"
        case challenger = "CHALLENGER"
    }

extension Tier {
    var order: Int {
        switch self {
        case .iron: return 1
        case .bronze3: return 2
        case .bronze2: return 3
        case .bronze1: return 4
        case .silver3: return 5
        case .silver2: return 6
        case .silver1: return 7
        case .gold3: return 8
        case .gold2: return 9
        case .gold1: return 10
        case .platinum3: return 11
        case .platinum2: return 12
        case .platinum1: return 13
        case .diamond3: return 14
        case .diamond2: return 15
        case .diamond1: return 16
        case .challenger: return 17
        }
    }

    var displayName: String {
        switch self {
        case .iron: return "아이언"
        case .bronze3: return "브론즈 III"
        case .bronze2: return "브론즈 II"
        case .bronze1: return "브론즈 I"
        case .silver3: return "실버 III"
        case .silver2: return "실버 II"
        case .silver1: return "실버 I"
        case .gold3: return "골드 III"
        case .gold2: return "골드 II"
        case .gold1: return "골드 I"
        case .platinum3: return "플래티넘 III"
        case .platinum2: return "플래티넘 II"
        case .platinum1: return "플래티넘 I"
        case .diamond3: return "다이아몬드 III"
        case .diamond2: return "다이아몬드 II"
        case .diamond1: return "다이아몬드 I"
        case .challenger: return "챌린저"
        }
    }

    var simpleDisplayName: String {
        switch self {
        case .iron: return "아이언"
        case .bronze3, .bronze2, .bronze1: return "브론즈"
        case .silver3, .silver2, .silver1: return "실버"
        case .gold3, .gold2, .gold1: return "골드"
        case .platinum3, .platinum2, .platinum1: return "플래티넘"
        case .diamond3, .diamond2, .diamond1: return "다이아몬드"
        case .challenger: return "챌린저"
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .iron:
            return .Tier.ironBackground
        case .bronze3, .bronze2, .bronze1:
            return .Tier.bronzeBackground
        case .silver3, .silver2, .silver1:
            return .Tier.silverBackground
        case .gold3, .gold2, .gold1:
            return .Tier.goldBackground
        case .platinum3, .platinum2, .platinum1:
            return .Tier.platinumBackground
        case .diamond3, .diamond2, .diamond1:
            return .Tier.diamondBackground
        case .challenger:
            return .Tier.challengerBackground
        }
    }

    var textColor: UIColor {
        switch self {
        case .iron:
            return .Tier.ironText
        case .bronze3, .bronze2, .bronze1:
            return .Tier.bronzeText
        case .silver3, .silver2, .silver1:
            return .Tier.silverText
        case .gold3, .gold2, .gold1:
            return .Tier.goldText
        case .platinum3, .platinum2, .platinum1:
            return .Tier.platinumText
        case .diamond3, .diamond2, .diamond1:
            return .Tier.diamondText
        case .challenger:
            return .Tier.challengerText
        }
    }

    static func from(tierId: Int) -> Tier? {
        switch tierId {
        case 1: return .iron
        case 2: return .bronze3
        case 3: return .bronze2
        case 4: return .bronze1
        case 5: return .silver3
        case 6: return .silver2
        case 7: return .silver1
        case 8: return .gold3
        case 9: return .gold2
        case 10: return .gold1
        case 11: return .platinum3
        case 12: return .platinum2
        case 13: return .platinum1
        case 14: return .diamond3
        case 15: return .diamond2
        case 16: return .diamond1
        case 17: return .challenger
        default: return nil
        }
    }

    static var filterTiers: [Tier] {
        return [
            .iron,
            .bronze1,
            .silver1,
            .gold1,
            .platinum1,
            .diamond1,
            .challenger
        ]
    }
}
