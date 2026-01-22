//
//  MatchingSearchService.swift
//  SMASHING
//
//  Created by JIN on 1/20/26.
//

import Foundation
import Combine

// MARK: - Protocol

protocol MatchingSearchServiceProtocol {
    func getUserProfileList(
        cursor: String?,
        size: Int?,
        gender: Gender?,
        tier: String?
    ) -> AnyPublisher<MatchingSearchViewUserDTO, NetworkError>
}

// MARK: - Service

final class MatchingSearchService: MatchingSearchServiceProtocol {

    func getUserProfileList(
        cursor: String?,
        size: Int?,
        gender: Gender?,
        tier: String?
    ) -> AnyPublisher<MatchingSearchViewUserDTO, NetworkError> {
        return NetworkProvider<MatchingSearchAPI>
            .requestPublisher(
                .getUserProfileList(
                    cursor: cursor,
                    size: size,
                    gender: gender,
                    tier: tier
                ),
                type: MatchingSearchViewUserDTO.self
            )
            .map { response in
                response.data
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Mock Service

final class MockMatchingSearchService: MatchingSearchServiceProtocol {

    func getUserProfileList(
        cursor: String?,
        size: Int?,
        gender: Gender?,
        tier: String?
    ) -> AnyPublisher<MatchingSearchViewUserDTO, NetworkError> {
        let mockResults: [MatchingSearchUserProfileDTO] = [
            MatchingSearchUserProfileDTO(
                userID: "TEST_USER_01",
                nickname: "후기왕",
                gender: .male,
                tierCode: "IR",
                wins: 3,
                losses: 2,
                reviews: 3
            ),
            MatchingSearchUserProfileDTO(
                userID: "TEST_USER_02",
                nickname: "경기왕",
                gender: .female,
                tierCode: "IR",
                wins: 5,
                losses: 5,
                reviews: 1
            ),
            MatchingSearchUserProfileDTO(
                userID: "TEST_USER_03",
                nickname: "가나다",
                gender: .male,
                tierCode: "IR",
                wins: 1,
                losses: 1,
                reviews: 1
            )
        ]

        let response = MatchingSearchViewUserDTO(
            snapshotAt: "2026-01-16T01:02:14.182253+09:00",
            results: mockResults,
            nextCursor: nil,
            hasNext: false
        )

        return Just(response)
            .delay(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
}
