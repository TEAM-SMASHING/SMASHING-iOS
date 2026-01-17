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
}
