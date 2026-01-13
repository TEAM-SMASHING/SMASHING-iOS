//
//  Sports.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

import UIKit

enum Sports: String, Codable {
    case tableTennis = "탁구"
    case tennis = "테니스"
    case badminton = "배드민턴"
    
    enum CodingKeys: String, CodingKey {
        case tableTennis = "TT"
        case tennis = "TN"
        case badminton = "BM"
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
