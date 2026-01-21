//
//  MatchingSearchAPI.swift
//  SMASHING
//
//  Created by JIN on 1/20/26.
//

import Foundation

import Moya
import Alamofire

enum MatchingSearchAPI {
    case getUserProfileList(cursor: String?, size: Int?, gender: Gender?, tier: String?)
}

extension MatchingSearchAPI: BaseTargetType {

    var path: String {
        switch self {
        case .getUserProfileList:
            return "api/v1/users/me/regions/users"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getUserProfileList:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .getUserProfileList(let cursor, let size, let gender, let tier):
            var parameters: [String: Any] = [:]
            if let cursor = cursor { parameters["cursor"] = cursor }
            if let size = size { parameters["size"] = size }
            if let gender = gender { parameters["gender"] = gender.rawValue }
            if let tier = tier { parameters["tier"] = tier }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }

    var headers: [String : String]? {
        guard let accessToken = KeychainService.get(key: Environment.accessTokenKey) else {
            return ["Content-Type": "application/json"]
        }

        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
    }
}
