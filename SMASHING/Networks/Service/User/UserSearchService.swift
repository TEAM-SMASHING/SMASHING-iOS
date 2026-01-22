//
//  SearchUserService.swift
//  SMASHING
//
//  Created by 이승준 on 1/19/26.
//

import Combine
import Foundation

protocol UserSearchServiceType {
    func searchUser(nickname: String) -> AnyPublisher<[UserSummary], NetworkError>
}

final class UserSearchService: UserSearchServiceType {
    func searchUser(nickname: String) -> AnyPublisher<[UserSummary], NetworkError> {
        return NetworkProvider<SearchUserAPI>
            .requestPublisher(.searchUser(nickname: nickname), type: UserSearchResponse.self)
            .map { response in
                return response.data.users
            }
            .eraseToAnyPublisher()
    }
}
