//
//  MatchingConfirmedAPI.swift
//  SMASHING
//
//  Created by Claude on 1/17/26.
//

import Foundation

import Moya
import Alamofire

enum MatchingConfirmedAPI {
    case getConfirmedGameList(snapshotAt: String?, cursor: String?, size: Int?, order: String?)
}

extension MatchingConfirmedAPI: BaseTargetType {

    var path: String {
        switch self {
        case .getConfirmedGameList:
            return "api/v1/users/me/games/pending-results"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getConfirmedGameList:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .getConfirmedGameList(let snapshotAt, let cursor, let size, let order):
            var parameters: [String: Any] = [:]
            if let snapshotAt = snapshotAt { parameters["snapshotAt"] = snapshotAt }
            if let cursor = cursor { parameters["cursor"] = cursor }
            if let size = size { parameters["size"] = size }
            if let order = order { parameters["order"] = order }
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
