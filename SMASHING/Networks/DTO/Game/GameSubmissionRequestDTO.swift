//
//  GameSubmissionRequestDTO.swift
//  SMASHING
//
//  Created by 홍준범 on 1/19/26.
//

import Foundation

struct GameFirstSubmissionRequestDTO: Encodable {
    let winnerUserId: String
    let loserUserId: String
    let scoreWinner: Int
    let scoreLoser: Int
    let review: ReviewRequestDTO
}

struct GameResubmissionRequestDTO: Encodable {
    let winnerUserId: String
    let loserUserId: String
    let scoreWinner: Int
    let scoreLoser: Int
}

struct ReviewRequestDTO: Encodable {
    let rating: String
    let content: String?
    let tags: [String]?
}


enum GameResultStatus: String, Codable {
    case pendingResult = "PENDING_RESULT"
    case waitingConfirmation = "WAITING_CONFIRMATION"
    case resultRejected = "RESULT_REJECTED"
    case canceled = "CANCELED"
    
    var canSubmit: Bool {
        switch self {
        case .pendingResult, .resultRejected:
            return true
        case .waitingConfirmation, .canceled:
            return false
        }
    }
    
    var isFirstSubmission: Bool {
        return self == .pendingResult
    }
    
    var buttonTitle: String {
        switch self {
        case .pendingResult:
            return "결과 작성하기"
        case .resultRejected:
            return "결과가 반려되었어요!"
        case .waitingConfirmation:
            return "결과 확인 대기 중"
        case .canceled:
            return "매칭 취소 대기 중"
        }
    }
}
