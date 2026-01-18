//
//  ProfileTierResponse.swift
//  SMASHING
//
//  Created by 이승준 on 1/19/26.
//

import Foundation

struct ProfileTierResponse: Decodable {
    let region: String
    let nickname: String
    let activeProfile: ActiveProfile
    let allProfiles: [SimpleProfile]
}

struct ActiveProfile: Decodable {
    let profileId: String
    let sportCode: Sports
    let tierCode: String
    let lp: Int
    let minLp: Int
    let maxLp: Int
    let wins: Int
    let losses: Int
    let reviews: Int?
    
//    var oreTier: OreTier? {
//        OreTier.allCases.first { $0.index == tierId }
//    }
}

struct SimpleProfile: Decodable {
    let profileId: String
    let sportCode: Sports
    
    private let isActive: Bool?
    private let isSelected: Bool?
        
    var isCurrentlySelected: Bool {
        return isActive ?? isSelected ?? false
    }

    enum CodingKeys: String, CodingKey {
        case profileId, sportCode, isActive, isSelected
    }
}
