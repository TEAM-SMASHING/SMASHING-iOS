//
//  GameResultSubmissionDetailResponseDTO.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

import Foundation

struct GameResultSubmissionDetailResponseDTO: Decodable {
    let attemptNo: Int
    let submitter: SubmitterSummaryDTO
    let winner: SideSummaryDTO
    let loser: SideSummaryDTO
}
