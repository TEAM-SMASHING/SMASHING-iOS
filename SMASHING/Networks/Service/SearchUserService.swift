//
//  SearchUserService.swift
//  SMASHING
//
//  Created by 이승준 on 1/19/26.
//

import Combine
import Foundation

protocol SearchUserServiceType {
    func searchUser(nickname: String) -> AnyPublisher<[UserSummary], NetworkError>
}

final class SearchUserService: SearchUserServiceType {
    func searchUser(nickname: String) -> AnyPublisher<[UserSummary], NetworkError> {
        return NetworkProvider<SearchUserTarget>
            .requestPublisher(.searchUser(nickname: nickname), type: UserSearchResponse.self)
            .map { response in
                // GenericResponse<UserSearchResponse>에서 유저 배열만 반환
                return response.data.users
            }
            .eraseToAnyPublisher()
    }
}
