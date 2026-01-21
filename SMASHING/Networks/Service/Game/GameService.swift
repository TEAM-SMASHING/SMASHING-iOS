//
//  GameService.swift
//  SMASHING
//
//  Created by 홍준범 on 1/19/26.
//

import Foundation
import Combine

protocol GameServiceProtocol {
    func submitResult(gameId: String, request: GameFirstSubmissionRequestDTO) -> AnyPublisher<GameSubmissionResponseDTO, NetworkError>
    func resubmitResult(gameId: String, request: GameResubmissionRequestDTO) -> AnyPublisher<GameSubmissionResponseDTO, NetworkError>
}

final class GameService: GameServiceProtocol {
    func submitResult(gameId: String, request: GameFirstSubmissionRequestDTO) -> AnyPublisher<GameSubmissionResponseDTO, NetworkError> {
        return NetworkProvider<GameAPI>
            .requestPublisher(.submissionResult(gameId: gameId, request: request), type: GameSubmissionResponseDTO.self)
            .map { response in
                response.data    
            }
            .eraseToAnyPublisher()
    }
    
    func resubmitResult(gameId: String, request: GameResubmissionRequestDTO) -> AnyPublisher<GameSubmissionResponseDTO, NetworkError> {
        return NetworkProvider<GameAPI>
            .requestPublisher(.resubmission(gameId: gameId, request: request), type: GameSubmissionResponseDTO.self)
            .map { response in
                response.data
            }
            .eraseToAnyPublisher()
    }
}
