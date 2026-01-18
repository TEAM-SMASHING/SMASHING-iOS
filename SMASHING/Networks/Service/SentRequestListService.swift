//
//  SentRequestListService.swift
//  SMASHING
//
//  Created by JIN on 1/17/26.
//

import Foundation
import Combine

// MARK: - SentRequestServiceProtocol

protocol SentRequestServiceProtocol {
    func getSentRequestList(
        snapshotAt: String?,
        cursor: String?,
        size: Int?
    ) -> AnyPublisher<SentRequestCursorResponseDTO, NetworkError>

    func cancelSentRequest(matchingId: String) -> AnyPublisher<Void, NetworkError>
}

// MARK: - SentRequestService

final class SentRequestService: SentRequestServiceProtocol {

    func getSentRequestList(
        snapshotAt: String?,
        cursor: String?,
        size: Int?
    ) -> AnyPublisher<SentRequestCursorResponseDTO, NetworkError> {
        return NetworkProvider<SentRequestResultAPI>
            .requestPublisher(
                .getSentRequestList(snapshotAt: snapshotAt, cursor: cursor, size: size),
                type: SentRequestCursorResponseDTO.self
            )
            .map { response in
                response.data
            }
            .eraseToAnyPublisher()
    }

    func cancelSentRequest(matchingId: String) -> AnyPublisher<Void, NetworkError> {
        return NetworkProvider<SentRequestResultAPI>
            .requestPublisher(
                .cancelSentRequest(matchingId: matchingId),
                type: EmptyResponse.self
            )
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}

// MARK: - EmptyResponse (취소 API 응답용)

struct EmptyResponse: Codable {}

// MARK: - MockSentRequestService

final class MockSentRequestService: SentRequestServiceProtocol {

    func getSentRequestList(
        snapshotAt: String?,
        cursor: String?,
        size: Int?
    ) -> AnyPublisher<SentRequestCursorResponseDTO, NetworkError> {
        let mockData = SentRequestCursorResponseDTO(
            snapshotAt: "2026-01-17T12:00:00+09:00",
            results: [
                SentRequestResultDTO(
                    matchingID: "MATCH001",
                    createdAt: "2026-01-17T10:00:00+09:00",
                    status: "REQUESTED",
                    receiver: SentRequestReceiverDTO(
                        userID: "0USER000111225",
                        nickname: "나는다섯글자인간임ㅅㄱ",
                        gender: "MALE",
                        reviewCount: 8,
                        tierCode: "GO1",
                        wins: 30,
                        losses: 15
                    )
                ),
                SentRequestResultDTO(
                    matchingID: "MATCH002",
                    createdAt: "2026-01-17T09:30:00+09:00",
                    status: "REQUESTED",
                    receiver: SentRequestReceiverDTO(
                        userID: "0USER000111226",
                        nickname: "하은",
                        gender: "FEMALE",
                        reviewCount: 4,
                        tierCode: "SV2",
                        wins: 15,
                        losses: 20
                    )
                ),
                SentRequestResultDTO(
                    matchingID: "MATCH003",
                    createdAt: "2026-01-17T09:00:00+09:00",
                    status: "REQUESTED",
                    receiver: SentRequestReceiverDTO(
                        userID: "0USER000111227",
                        nickname: "스매싱왕",
                        gender: "MALE",
                        reviewCount: 15,
                        tierCode: "DM1",
                        wins: 50,
                        losses: 10
                    )
                )
            ],
            nextCursor: cursor == nil ? "eyJpZCI6Ik1BVENIMDAzIn0" : nil,
            hasNext: cursor == nil
        )

        return Just(mockData)
            .delay(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }

    func cancelSentRequest(matchingId: String) -> AnyPublisher<Void, NetworkError> {
        return Just(())
            .delay(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
}
