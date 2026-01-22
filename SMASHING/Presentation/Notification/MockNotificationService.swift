//
//  File.swift
//  SMASHING
//
//  Created by 이승준 on 1/23/26.
//

import Combine
import Foundation

final class MockNotificationService: NotificationServiceProtocol {
    
    func fetchNotifications(size: Int, cursor: String?, snapshotAt: String?) -> AnyPublisher<GenericResponse<NotificationCursorResponseDTO>, NetworkError> {
        
        let mockResults: [NotificationSummaryResponseDTO] = [
            createMockSummary(id: "1", type: .matchingRequested, sport: .tennis),
            createMockSummary(id: "2", type: .matchingAccepted, sport: .badminton),
            createMockSummary(id: "3", type: .matchingResultSubmitted, sport: .tableTennis),
            createMockSummary(id: "4", type: .resultRejectedScoreMismatch, sport: .tennis),
            createMockSummary(id: "5", type: .resultRejectedWinLoseReversed, sport: .badminton),
            createMockSummary(id: "6", type: .reviewReceived, sport: .tableTennis),
            createMockSummary(id: "7", type: .resultRejectedScoreAndWinLoseMismatch, sport: .tennis),
            createMockSummary(id: "8", type: .resultRejectedGameNotPlayedYet, sport: .badminton)
        ]
        
        let cursorResponse = NotificationCursorResponseDTO(
            snapshotAt: snapshotAt ?? "2026-01-22T04:24:00Z",
            results: Array(mockResults.prefix(size)),
            nextCursor: "next_cursor_123",
            hasNext: true
        )
        
        let response = GenericResponse(status: "200", statusCode: 200, data: cursorResponse, timestamp: "")
        
        return Just(response)
            .setFailureType(to: NetworkError.self)
            .delay(for: .seconds(0.3), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func markAsRead(notificationId: String) -> AnyPublisher<NotificationBaseResponseDTO, NetworkError> {
        let baseResponse = NotificationBaseResponseDTO(
            status: "SUCCESS",
            statusCode: 200,
            message: "알림 읽음 처리 성공",
            errorCode: nil,
            errorName: nil,
            timestamp: "2026-01-22T04:24:00Z"
        )
        
        return Just(baseResponse)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Helper Methods
    
    private func createMockSummary(id: String, type: NotificationType, sport: IntSports) -> NotificationSummaryResponseDTO {
        return NotificationSummaryResponseDTO(
            notificationId: id,
            type: type,
            title: type.displayText,
            content: "\(sport.displayName) 종목에서 \(type.displayText) 알림이 도착했습니다.",
            linkUrl: "smashing://notifications/\(id)",
            isRead: false,
            createdAt: "2026-01-22T04:00:00Z",
            senderNickname: "매칭상대",
            receiverProfileId: "user_777",
            receiverSportId: sport
        )
    }
}
