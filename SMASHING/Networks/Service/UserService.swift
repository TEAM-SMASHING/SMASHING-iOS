//
//  UserService.swift
//  SMASHING
//
//  Created by 이승준 on 1/17/26.
//

import Foundation
import Combine

protocol UserServiceProtocol {
    func checkNicknameAvailability(nickname: String) -> AnyPublisher<Bool, NetworkError>
    func validateOpenchatUrl(url: String) -> AnyPublisher<Bool, NetworkError>
}

final class UserService: UserServiceProtocol {
    func checkNicknameAvailability(nickname: String) -> AnyPublisher<Bool, NetworkError> {
        return NetworkProvider<UserAPI>
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
        return NetworkProvider<UserAPI>
            .requestPublisher(.validateOpenchatUrl(url: url), type: OpenchatValidationDTO.self)
            .map { response in
                // 서버 응답의 valid 값을 반환
                return response.data.valid
            }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
