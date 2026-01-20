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
