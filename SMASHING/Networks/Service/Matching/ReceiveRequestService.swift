//
//  ReceiveRequestService.swift
//  SMASHING
//
//  Created by JIN on 1/18/26.
//

import Foundation
import Combine

// MARK: - Protocol

protocol ReceiveRequestServiceProtocol {
    
    func getReceivedRequestList(
        snapshotAt: String?,
        cursor: String?,
        size: Int?
    ) -> AnyPublisher<ReceiveRequestCursorResponseDTO, NetworkError>

    func acceptRequest(matchingId: String) -> AnyPublisher<Void, NetworkError>
    
    func rejectRequest(matchingId: String) -> AnyPublisher<Void, NetworkError>

}

// MARK: - Service

final class ReceiveRequestService: ReceiveRequestServiceProtocol {

    func getReceivedRequestList(
        snapshotAt: String?,
        cursor: String?,
        size: Int?
    ) -> AnyPublisher<ReceiveRequestCursorResponseDTO, NetworkError> {
        return NetworkProvider<ReceiveRequestAPI>
            .requestPublisher(
                .getReceivedRequestList(snapshotAt: snapshotAt, cursor: cursor, size: size),
                type: ReceiveRequestCursorResponseDTO.self
            )
            .map { response in
                response.data
            }
            .eraseToAnyPublisher()
    }

    func acceptRequest(matchingId: String) -> AnyPublisher<Void, NetworkError> {
        return NetworkProvider<ReceiveRequestAPI>
            .requestPublisher(
                .acceptRequest(matchingId: matchingId),
                type: EmptyResponse.self
            )
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    func rejectRequest(matchingId: String) -> AnyPublisher<Void, NetworkError> {
        return NetworkProvider<ReceiveRequestAPI>
            .requestPublisher(
                .rejectRequest(matchingID: matchingId),
                type: EmptyResponse.self
            )
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
}

// MARK: - Mock Service

final class MockReceiveRequestService: ReceiveRequestServiceProtocol {

    func getReceivedRequestList(
        snapshotAt: String?,
        cursor: String?,
        size: Int?
    ) -> AnyPublisher<ReceiveRequestCursorResponseDTO, NetworkError> {
        let mockResults: [ReceiveRequestResultDTO] = [
            ReceiveRequestResultDTO(
                matchingID: "0P4ZQSTKAN4ZR",
                createdAt: "2026-01-12T03:16:31+09:00",
                status: "REQUESTED",
                requester: RequesterSummaryDTO(
                    userID: "0KGHK8KM7TNX6",
                    nickname: "공공",
                    gender: Gender.male,
                    reviewCount: 2,
                    tierCode: "BR2",
                    wins: 2,
                    losses: 0
                )
            ),
            ReceiveRequestResultDTO(
                matchingID: "0P4ZQSRGTN4VT",
                createdAt: "2026-01-12T03:16:30+09:00",
                status: "REQUESTED",
                requester: RequesterSummaryDTO(
                    userID: "0KGHK8KM7TNX6",
                    nickname: "테니스왕",
                    gender: Gender.female,
                    reviewCount: 5,
                    tierCode: "SV1",
                    wins: 10,
                    losses: 3
                )
            )
        ]

        let response = ReceiveRequestCursorResponseDTO(
            snapshotAt: "2026-01-12T05:30:56.649619+09:00",
            results: mockResults,
            nextCursor: nil,
            hasNext: false
        )

        return Just(response)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func acceptRequest(matchingId: String) -> AnyPublisher<Void, NetworkError> {
        return Just(())
            .delay(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func rejectRequest(matchingId: String) -> AnyPublisher<Void, NetworkError> {
        return Just(())
            .delay(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
}
