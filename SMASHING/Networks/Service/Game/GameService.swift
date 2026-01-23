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
    func getSubmissionDetail(gameId: String, submissionId: String) -> AnyPublisher<GameSubmissionDetailDTO, NetworkError>
    func rejectSubmission(gameId: String, submissionId: String, reason: String?) -> AnyPublisher<Void, NetworkError>
    func confirmSubmission(gameId: String, submissionId: String, review: ReviewRequestDTO) -> AnyPublisher<GameConfirmResponseDTO, NetworkError>
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
    
    func getSubmissionDetail(gameId: String, submissionId: String) -> AnyPublisher<GameSubmissionDetailDTO, NetworkError> {
            return NetworkProvider<GameAPI>
                .requestPublisher(.seeSubmission(gameId: gameId, submissionId: submissionId), type: GameSubmissionDetailDTO.self)
                .map { response in
                    response.data
                }
                .eraseToAnyPublisher()
        }

    func rejectSubmission(gameId: String, submissionId: String, reason: String?) -> AnyPublisher<Void, NetworkError> {
        let request = GameRejectRequestDTO(reason: reason)
            return NetworkProvider<GameAPI>
            .requestPublisher(.rejectSubmission(gameId: gameId, submissionId: submissionId, request: request), type: EmptyDataDTO.self)
                .map { _ in () }
                .eraseToAnyPublisher()
        }
    
    func confirmSubmission(gameId: String, submissionId: String, review: ReviewRequestDTO) -> AnyPublisher<GameConfirmResponseDTO, NetworkError> {
            let request = GameConfirmRequestDTO(review: review)
            return NetworkProvider<GameAPI>
                .requestPublisher(.submissionConfirm(gameId: gameId, submissionId: submissionId, request: request), type: GameConfirmResponseDTO.self)
                .map { response in
                    response.data
                }
                .eraseToAnyPublisher()
        }
}
