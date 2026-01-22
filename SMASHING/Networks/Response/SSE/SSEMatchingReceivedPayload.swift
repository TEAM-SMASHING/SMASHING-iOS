//
//  File.swift
//  SMASHING
//
//  Created by 이승준 on 1/22/26.
//

import Foundation

struct SSEMatchingReceivedPayload: Codable {
    let type: String
    let matchingId: String
    let sportId: Int64
    let receiverProfileId: String
    let requester: SSERequesterSummary
}

struct SSERequesterSummary: Codable {
    let userId: String
    let nickname: String
    let gender: String
    let tierCode: String
    let wins: Int
    let losses: Int
    let reviewCount: Int64
}
