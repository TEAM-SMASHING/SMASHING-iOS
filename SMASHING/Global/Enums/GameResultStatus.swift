//
//  GameResultStatus.swift
//  SMASHING
//
//  Created by 홍준범 on 1/20/26.
//

import Foundation

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
