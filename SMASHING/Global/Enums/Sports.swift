//
//  Sports.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

import UIKit

enum Sports: Int, Codable, CaseIterable {
    case tableTennis = 1
    case tennis = 2
    case badminton = 3
    
    var code: String {
        switch self {
        case .tableTennis: return "TT"
        case .tennis: return "TN"
        case .badminton: return "BM"
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
