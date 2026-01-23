//
//  File.swift
//  SMASHING
//
//  Created by 이승준 on 1/22/26.
//

import Foundation

struct SSEMatchingUpdatedPayload: Codable {
    let type: String
    let matchingId: String
    let status: SSEMatchingUpdatedPayloadState
}

enum SSEMatchingUpdatedPayloadState: String, Codable {
    case cancelled  = "CANCELLED"
    case rejected = "REJECTED"
    case accepted = "ACCEPTED"
}
