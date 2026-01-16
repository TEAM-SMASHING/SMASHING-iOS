//
//  SentRequestResultDTO.swift
//  SMASHING
//
//  Created by JIN on 1/17/26.
//

import UIKit

struct SentRequestResultDTO: Codable {
    let matchingID: String
    let createdAt: Date
    let status: String
    let receiver: SentRequestReceiverDTO
    
    enum CodingKeys: String, CodingKey {
        case matchingID = "matchingId"
        case createdAt, status, receiver
    }
}

// MARK: - Receiver
struct SentRequestReceiverDTO: Codable {
    let userID : String
    let nickname: String
    let gender: String
    let reviewCount: Int
    let tierID: Int
    let tierName: String
    let wins: Int
    let losses: Int
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname, gender, reviewCount
        case tierID = "tierId"
        case tierName, wins, losses
    }
}
