//
//  UserAPI.swift
//  SMASHING
//
//  Created by 이승준 on 1/17/26.
//

import Foundation

import Alamofire
import Moya

enum UserAPI {
    case checkNicknameAvailability(nickname: String)
}

extension UserAPI: BaseTargetType {
    var path: String {
        switch self {
        case .checkNicknameAvailability:
            return "/api/v1/users/nickname-availability"
        }
    }

    var method: Moya.Method {
        switch self {
        case .checkNicknameAvailability:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .checkNicknameAvailability(let nickname):
            return .requestParameters(
                parameters: ["nickname": nickname],
                encoding: URLEncoding.queryString
            )
        }
    }
}
