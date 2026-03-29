//
//  AuthReissueAPI.swift
//  SMASHING
//

import Moya
import Alamofire

enum AuthReissueAPI {
    case reissue(refreshToken: String)
}

extension AuthReissueAPI: BaseTargetType {
    var path: String {
        switch self {
        case .reissue:
            return "/api/v1/auth/reissue"
        }
    }

    var method: Moya.Method {
        switch self {
        case .reissue:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .reissue(let refreshToken):
            let parameters = [
                "refreshToken": refreshToken
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }

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
