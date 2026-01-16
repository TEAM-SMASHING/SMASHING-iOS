//
//  Type.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

import UIKit

enum Gender: String, Codable {
    case male = "MALE"
    case female = "FEMALE"
    
    var displayName: String {
        switch self {
        case .male:
            return "남성"
        case .female:
            return "여성"
        }
    }
    
    var imageLg: UIImage {
        switch self {
        case .male:
            .icManLg
        case .female:
            .icWomanLg
        }
    }

    var imageSm: UIImage {
        switch self {
        case .male:
            .icManSm
        case .female:
            .icWomanSm
        }
    }
}
