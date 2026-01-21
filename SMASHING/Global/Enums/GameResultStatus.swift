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
        case .resultConfirmed:
            return "결과 확인하기"
        }
    }
    
    /// WAITING_CONFIRMATION 상태에서 내가 제출자인지에 따라 버튼 타이틀 결정
    func buttonTitle(isMySubmission: Bool) -> String {
        switch self {
        case .waitingConfirmation:
            return isMySubmission ? "결과 확인 대기 중" : "경기 결과 확인하기"
        default:
            return buttonTitle
        }
    }
    
    /// WAITING_CONFIRMATION 상태에서 상대방이 제출했으면 확인 가능
    func canConfirm(isMySubmission: Bool) -> Bool {
        return self == .waitingConfirmation && !isMySubmission
    }
}
