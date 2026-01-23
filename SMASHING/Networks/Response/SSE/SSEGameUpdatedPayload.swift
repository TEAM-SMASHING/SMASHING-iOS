//
//  SSEGameUpdatedPayload.swift
//  SMASHING
//
//  Created by 이승준 on 1/22/26.
//

import Foundation

struct SSEGameUpdatedPayload: Codable {
    let type: String
    let gameId: String
    let submissionId: String
    let resultStatus: GameResultStatus
    let submissionAttemptNo: Int
}
