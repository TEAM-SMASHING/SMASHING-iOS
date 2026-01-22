//
//  MatchingConfirmedService.swift
//  SMASHING
//
//  Created by JIN on 1/17/26.
//

import Foundation
import Combine

// MARK: - MatchingConfirmedServiceProtocol

protocol MatchingConfirmedServiceProtocol {
    func getConfirmedGameList(
        snapshotAt: String?,
        cursor: String?,
        size: Int?,
        order: String?
    ) -> AnyPublisher<MatchingConfirmedCursorResponseDTO, NetworkError>

    func cancelGame(gameId: String) -> AnyPublisher<Void, NetworkError>
}

// MARK: - MatchingConfirmedService

final class MatchingConfirmedService: MatchingConfirmedServiceProtocol {
    
    func getConfirmedGameList(
        snapshotAt: String?,
        cursor: String?,
        size: Int?,
        order: String?
    ) -> AnyPublisher<MatchingConfirmedCursorResponseDTO, NetworkError> {
        return NetworkProvider<MatchingConfirmedAPI>
            .requestPublisher(
                .getConfirmedGameList(
                    snapshotAt: snapshotAt,
                    cursor: cursor,
                    size: size,
                    order: order),
                type: MatchingConfirmedCursorResponseDTO.self
            )
            .map { response in
                response.data
            }
            .eraseToAnyPublisher()
    }
    
    func cancelGame(gameId: String) -> AnyPublisher<Void, NetworkError> {
        return NetworkProvider<MatchingConfirmedAPI>
            .requestPublisher(
                .cancelGame(gameId: gameId)
                , type: EmptyResponse.self
            )
            .map { _ in }
            .eraseToAnyPublisher()
    }
}

// MARK: - MockMatchingConfirmedService

//final class MockMatchingConfirmedService: MatchingConfirmedServiceProtocol {
//
//    func getConfirmedGameList(
//        snapshotAt: String?,
//        cursor: String?,
//        size: Int?,
//        order: String?
//    ) -> AnyPublisher<MatchingConfirmedCursorResponseDTO, NetworkError> {
//        let mockData = MatchingConfirmedCursorResponseDTO(
//            snapshotAt: "2026-01-17T12:00:00+09:00",
//            results: [
//                MatchingConfirmedGameDTO(
//                    gameID: "0P4G1GZ5AF0XG",
//                    resultStatus: GameResultStatus(rawValue: "RESULT_REJECTED") ?? .canceled,
//                    createdAt: "2026-01-17T10:00:00+09:00",
//                    opponent: OpponentSummaryDTO(
//                        userID: "0USER000111227",
//                        nickname: "도윤",
//                        openchatUrl: "https://open.kakao.com/o/example1",
//                        gender: "MALE",
//                        tierCode: "PT1"
//                    ),
//                    submitAvailableAt: "2026-01-17T11:00:00+09:00",
//                    remainingSeconds: 1570,
//                    isSubmitLocked: true
//                ),
//                MatchingConfirmedGameDTO(
//                    gameID: "0P3M3MGSH4MZG",
//                    resultStatus: GameResultStatus(rawValue: "WAITING_CONFIRMATION") ?? .pendingResult,
//                    createdAt: "2026-01-17T09:30:00+09:00",
//                    opponent: OpponentSummaryDTO(
//                        userID: "0USER000111228",
//                        nickname: "수아",
//                        openchatUrl: "https://open.kakao.com/o/example2",
//                        gender: "FEMALE",
//                        tierCode: "DM1"
//                    ),
//                    submitAvailableAt: "2026-01-17T10:30:00+09:00",
//                    remainingSeconds: 0,
//                    isSubmitLocked: false
//                ),
//                MatchingConfirmedGameDTO(
//                    gameID: "0P2K2KFSG3LYF",
//                    resultStatus: GameResultStatus(rawValue: "PENDING_RESULT") ?? .pendingResult,
//                    createdAt: "2026-01-17T09:00:00+09:00",
//                    opponent: OpponentSummaryDTO(
//                        userID: "0USER000111229",
//                        nickname: "예준",
//                        openchatUrl: nil,
//                        gender: "MALE",
//                        tierCode: "CH"
//                    ),
//                    submitAvailableAt: "2026-01-17T10:00:00+09:00",
//                    remainingSeconds: 0,
//                    isSubmitLocked: false
//                )
//            ],
//            nextCursor: cursor == nil ? "eyJpZCI6IjBQMksyS0ZTRzNMWUYifQ" : nil,
//            hasNext: cursor == nil
//        )
//
//        return Just(mockData)
//            .delay(for: .milliseconds(500), scheduler: DispatchQueue.main)
//            .setFailureType(to: NetworkError.self)
//            .eraseToAnyPublisher()
//    }
//}

//    func cancelGame(gameId: String) -> AnyPublisher<Void, NetworkError> {
//        return Just(())
//            .delay(for: .milliseconds(300), scheduler: DispatchQueue.main)
//            .setFailureType(to: NetworkError.self)
//            .eraseToAnyPublisher()
//    }
//
//    func getConfirmedGameList(
//        snapshotAt: String?,
//        cursor: String?,
//        size: Int?,
//        order: String?
//    ) -> AnyPublisher<MatchingConfirmedCursorResponseDTO, NetworkError> {
//        let mockData = MatchingConfirmedCursorResponseDTO(
//            snapshotAt: "2026-01-17T12:00:00+09:00",
//            results: [
//                MatchingConfirmedGameDTO(
//                    gameID: "0P4G1GZ5AF0XG",
//                    resultStatus: GameResultStatus.resultRejected,
//                    createdAt: "2026-01-17T10:00:00+09:00",
//                    opponent: OpponentSummaryDTO(
//                        userID: "0USER000111227",
//                        nickname: "도윤",
//                        openchatUrl: "https://open.kakao.com/o/example1",
//                        gender: .male,
//                        tierCode: "PT1"
//                    ),
//                    submitAvailableAt: "2026-01-17T11:00:00+09:00",
//                    remainingSeconds: 1570,
//                    isSubmitLocked: true
//                ),
//                MatchingConfirmedGameDTO(
//                    gameID: "0P3M3MGSH4MZG",
//                    resultStatus: GameResultStatus.waitingConfirmation,
//                    createdAt: "2026-01-17T09:30:00+09:00",
//                    opponent: OpponentSummaryDTO(
//                        userID: "0USER000111228",
//                        nickname: "수아",
//                        openchatUrl: "https://open.kakao.com/o/example2",
//                        gender: .female,
//                        tierCode: "DM1"
//                    ),
//                    submitAvailableAt: "2026-01-17T10:30:00+09:00",
//                    remainingSeconds: 0,
//                    isSubmitLocked: false
//                ),
//                MatchingConfirmedGameDTO(
//                    gameID: "0P2K2KFSG3LYF",
//                    resultStatus: GameResultStatus.pendingResult,
//                    createdAt: "2026-01-17T09:00:00+09:00",
//                    opponent: OpponentSummaryDTO(
//                        userID: "0USER000111229",
//                        nickname: "예준",
//                        openchatUrl: nil,
//                        gender: .male,
//                        tierCode: "CH"
//                    ),
//                    submitAvailableAt: "2026-01-17T10:00:00+09:00",
//                    remainingSeconds: 0,
//                    isSubmitLocked: false
//                )
//            ],
//            nextCursor: cursor == nil ? "eyJpZCI6IjBQMksyS0ZTRzNMWUYifQ" : nil,
//            hasNext: cursor == nil
//        )
//        
//        return Just(mockData)
//            .delay(for: .milliseconds(500), scheduler: DispatchQueue.main)
//            .setFailureType(to: NetworkError.self)
//            .eraseToAnyPublisher()
//    }
//}
//
