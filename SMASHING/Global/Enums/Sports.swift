//
//  Sports.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

import UIKit

enum Sports: String, Codable, CaseIterable {
    case tableTennis = "TT"
    case tennis = "TN"
    case badminton = "BM"
    
    var intCode: Int {
        switch self {
        case .tableTennis: return 1
        case .tennis: return 2
        case .badminton: return 3
        }
    }
    
    var displayName: String {
        switch self {
        case .tableTennis: return "탁구"
        case .tennis: return "테니스"
        case .badminton: return "배드민턴"
        }
    }
    
    var image: UIImage {
        switch self {
        case .tableTennis:
                .icPingpong
        case .tennis:
                .icTennis
        case .badminton:
                .icBadminton
        }
    }
    
    static func image(from code: String?) -> UIImage {
        guard let code,
              let sport = Sports(rawValue: code) else {
            return .icBadminton   // 기본 이미지
        }
        return sport.image
    }
}

enum IntSports: Int, Codable, CaseIterable {
    case tableTennis = 1
    case tennis = 2
    case badminton = 3
    
    var intCode: Int {
        switch self {
        case .tableTennis: return 1
        case .tennis: return 2
        case .badminton: return 3
        }
    }
    
    var displayName: String {
        switch self {
        case .tableTennis: return "탁구"
        case .tennis: return "테니스"
        case .badminton: return "배드민턴"
        }
    }
    
    var image: UIImage {
        switch self {
        case .tableTennis:
                .icPingpong
        case .tennis:
                .icTennis
        case .badminton:
                .icBadminton
        }
    }
}

