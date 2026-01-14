//
//  Tier.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

enum Tier: Codable {
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
}
