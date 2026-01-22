//
//  NotificationType.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

enum NotificationType: String, Codable {
    case matchingRequested = "MATCHING_REQUESTED"
    case matchingAccepted = "MATCHING_ACCEPTED"
    case matchingResultSubmitted = "MATCHING_RESULT_SUBMITTED"
    case resultRejectedScoreMismatch = "RESULT_REJECTED_SCORE_MISMATCH"
    case resultRejectedWinLoseReversed = "RESULT_REJECTED_WIN_LOSE_REVERSED"
    case reviewReceived = "REVIEW_RECEIVED"
    case resultRejectedScoreAndWinLoseMismatch  = "RESULT_REJECTED_SCORE_AND_WIN_LOSE_MISMATCH"
    case resultRejectedGameNotPlayedYet = "RESULT_REJECTED_GAME_NOT_PLAYED_YET"
    
    var displayText: String {
        switch self {
        case .matchingRequested: return "매칭 신청 도착"
        case .matchingAccepted: return "매칭 수락됨"
        case .matchingResultSubmitted: return "매칭 결과 전송됨"
        case .resultRejectedScoreMismatch: return "결과 반려 - 점수 오류"
        case .resultRejectedWinLoseReversed: return "결과 반려 - 승패 오류"
        case .reviewReceived: return "후기 도착"
        case .resultRejectedScoreAndWinLoseMismatch: return "결과 반려 - 점수 + 승패 오류"
        case .resultRejectedGameNotPlayedYet: return "결과 반려 - 진행되지 않은 게임"
        }
    }
}
