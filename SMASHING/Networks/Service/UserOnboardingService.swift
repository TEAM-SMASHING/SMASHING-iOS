//
//  UserService.swift
//  SMASHING
//
//  Created by 이승준 on 1/17/26.
//

import Foundation
import Combine

protocol UserOnboardingServiceProtocol {
    func checkNicknameAvailability(nickname: String) -> AnyPublisher<Bool, NetworkError>
    func validateOpenchatUrl(url: String) -> AnyPublisher<Bool, NetworkError>
    func signup(request: SignupRequestDTO) -> AnyPublisher<SignupDataDTO, NetworkError>
}

final class UserOnboardingService: UserOnboardingServiceProtocol {
    func checkNicknameAvailability(nickname: String) -> AnyPublisher<Bool, NetworkError> {
        return NetworkProvider<OnboardingUserAPI>
            .requestPublisher(.checkNicknameAvailability(nickname: nickname), type: NicknameAvailabilityDTO.self)
            .map { response in
                return response.data.available
            }
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }
    
    func validateOpenchatUrl(url: String) -> AnyPublisher<Bool, NetworkError> {
        return NetworkProvider<OnboardingUserAPI>
            .requestPublisher(.validateOpenchatUrl(url: url), type: OpenchatValidationDTO.self)
            .map { response in
                return response.data.valid
            }
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }
    
    func signup(request: SignupRequestDTO) -> AnyPublisher<SignupDataDTO, NetworkError> {
        return NetworkProvider<OnboardingUserAPI>
            .requestPublisher(.signup(request: request), type: SignupDataDTO.self)
            .map { response in
                return response.data
            }
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }
}
