//
//  UserAccountAPI.swift
//  SMASHING
//

import Moya
import Alamofire

enum UserAccountAPI {
    case logout
    case withdraw
}

extension UserAccountAPI: BaseTargetType {
    var path: String {
        switch self {
        case .logout:   return "/api/v1/auth/logout"
        case .withdraw: return "/api/v1/auth/withdraw"
        }
    }

    var method: Moya.Method {
        switch self {
        case .logout:   return .post
        case .withdraw: return .post
        }
    }

    var task: Task { .requestPlain }

    var headers: [String: String]? {
        guard let accessToken = KeychainService.get(key: Environment.accessTokenKey) else {
            return ["Content-Type": "application/json"]
        }
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
    }
}
