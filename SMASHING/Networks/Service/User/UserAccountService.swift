//
//  UserAccountService.swift
//  SMASHING
//

import Combine

protocol UserAccountServiceType {
    func logout() -> AnyPublisher<Void, NetworkError>
    func withdraw() -> AnyPublisher<Void, NetworkError>
}

final class UserAccountService: UserAccountServiceType {
    func logout() -> AnyPublisher<Void, NetworkError> {
        NetworkProvider<UserAccountAPI>
            .requestPublisher(.logout, type: EmptyDataDTO.self)
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    func withdraw() -> AnyPublisher<Void, NetworkError> {
        NetworkProvider<UserAccountAPI>
            .requestPublisher(.withdraw, type: EmptyDataDTO.self)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
