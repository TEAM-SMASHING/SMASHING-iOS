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
    
}

extension Tier {
    
    var displayName: String {
        switch self {
        case .iron: return "Iron"
        case .bronze3: return "Bronze III"
        case .bronze2: return "Bronze II"
        case .bronze1: return "Bronze I"
        case .silver3: return "Silver III"
        case .silver2: return "Silver II"
        case .silver1: return "Silver I"
        case .gold3: return "Gold III"
        case .gold2: return "Gold II"
        case .gold1: return "Gold I"
        case .platinum3: return "Platinum III"
        case .platinum2: return "Platinum II"
        case .platinum1: return "Platinum I"
        case .diamond3: return "Diamond III"
        case .diamond2: return "Diamond II"
        case .diamond1: return "Diamond I"
        case .challenger: return "Challenger"
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
    
    static func from(tierCode: String) -> Tier? {
        switch tierCode {
        case "IR": return .iron
        case "BR3": return .bronze3
        case "BR2": return .bronze2
        case "BR1": return .bronze1
        case "SV3": return .silver3
        case "SV2": return .silver2
        case "SV1": return .silver1
        case "GO3": return .gold3
        case "GO2": return .gold2
        case "GO1": return .gold1
        case "PT3": return .platinum3
        case "PT2": return .platinum2
        case "PT1": return .platinum1
        case "DM3": return .diamond3
        case "DM2": return .diamond2
        case "DM1": return .diamond1
        case "CH": return .challenger
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
    
    var image: UIImage {
        switch self {
        case .iron:
            .tierIronStage
        case .bronze3:
            .tierBronzeStage3
        case .bronze2:
            .tierBronzeStage2
        case .bronze1:
            .tierBronzeStage1
        case .silver3:
            .tierSilverStage3
        case .silver2:
            .tierSilverStage2
        case .silver1:
            .tierSilverStage1
        case .gold3:
            .tierGoldStage3
        case .gold2:
            .tierGoldStage2
        case .gold1:
            .tierGoldStage1
        case .platinum3:
            .tierPlatinumStage3
        case .platinum2:
            .tierPlatinumStage2
        case .platinum1:
            .tierPlatinumStage1
        case .diamond3:
            .tierDiamondStage3
        case .diamond2:
            .tierDiamondStage2
        case .diamond1:
            .tierDiamondStage1
        case .challenger:
            .tierChallengerStage
        }
    }
}
