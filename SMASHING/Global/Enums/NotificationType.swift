//
//  NotificationType.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

enum NotificationType: String, Codable {
    case matchingRequested = "매칭 신청 도착"
    case matchingAccepted = "매칭 수락됨"
    case matchingResultSubmitted = "매칭 결과 전송됨"
    case resultRejectedScoreMismatch = "결과 반려 - 점수 오류"
    case resultRejectedWinLoseReversed = "결과 반려 - 승패 오류"
    case reviewReceived = "후기 도착"
    
    enum CodingKeys: String, CodingKey {
        case matchingRequested = "MATCHING_REQUESTED"
        case matchingAccepted = "MATCHING_ACCEPTED"
        case matchingResultSubmitted = "MATCHING_RESULT_SUBMITTED"
        case resultRejectedScoreMismatch = "RESULT_REJECTED_SCORE_MISMATCH"
        case resultRejectedWinLoseReversed = "RESULT_REJECTED_WIN_LOSE_REVERSED"
        case reviewReceived = "REVIEW_RECEIVED"
    }
}
