//
//  GameResultState.swift
//  SMASHING
//
//  Created by JIN on 1/19/26.
//

import Foundation

enum GameResultStatus: String, Codable {
    case pendingResult = "PENDING_RESULT"
    case waitingConfirmation = "WAITING_CONFIRMATION"
    case resultRejected = "RESULT_REJECTED"
    case canceled = "CANCELED"
    case resultConfirmed = "RESULT_CONFIRMED"
    
    var canSubmit: Bool {
        switch self {
        case .pendingResult, .resultRejected, .resultConfirmed:
            return true
        case .waitingConfirmation, .canceled:
            return false
        }
    }
    
    var isFirstSubmission: Bool {
        return self == .pendingResult
    }
}
