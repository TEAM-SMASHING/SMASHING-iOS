//
//  MatchingRequestService.swift
//  SMASHING
//
//  Created by JIN on 1/22/26.
//

import Foundation
import Combine

// MARK: - Protocol

protocol MatchingRequestServiceProtocol {
    func requestMatching(receiverProfileId: String) -> AnyPublisher<Void, NetworkError>
}

// MARK: - Service

final class MatchingRequestService: MatchingRequestServiceProtocol {
    func requestMatching(receiverProfileId: String) -> AnyPublisher<Void, NetworkError> {
        return NetworkProvider<MatchingRequestAPI>
            .requestPublisher(
                .requestMatching(receiverProfileId: receiverProfileId),
                type: EmptyResponse.self
            )
            .map { _ in }
            .eraseToAnyPublisher()
    }
}
