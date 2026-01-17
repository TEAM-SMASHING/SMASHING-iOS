//
//  RankingResponse.swift
//  SMASHING
//
//  Created by 홍준범 on 1/17/26.
//

import Foundation

struct RankingResponseDTO: Decodable {
    let topUsers: [RankingUserDTO]
    let user: MyRankingDTO?
}

struct RankingUserDTO: Decodable {
    let rank: Int
    let userId: String
    let nickname: String
    let tierId: Int64
    let lp: Int
    
    var tier: Tier? {
        return Tier.from(tierId: Int(tierId))
    }
    
    var tierWithLpText: String {
        let tierName = tier?.displayName ?? "UNKNOWN"
        return "\(tierName) \(lp)P"
    }
}

struct MyRankingDTO: Decodable {
    let nickName: String
    let tierId: Int64
    let lp: Int
    
    var tier: Tier? {
        return Tier.from(tierId: Int(tierId))
    }
    
    var tierWithLpText: String {
        let tierName = tier?.displayName ?? "UNKNOWN"
        return "\(tierName) \(lp)P"
    }
}


