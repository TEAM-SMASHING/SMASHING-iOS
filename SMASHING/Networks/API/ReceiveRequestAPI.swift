//
//  ReceiveRequestAPI.swift
//  SMASHING
//
//  Created by JIN on 1/18/26.
//

import Foundation

import Moya
import Alamofire

enum ReceiveRequestAPI {
    case getReceivedRequestList(snapshotAt: String?, cursor: String?, size: Int?)
}

extension ReceiveRequestAPI: BaseTargetType {

    var path: String {
        switch self {
        case .getReceivedRequestList:
            return "api/v1/users/me/matchings/received"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getReceivedRequestList:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .getReceivedRequestList(let snapshotAt, let cursor, let size):
            var parameters: [String: Any] = [:]
            if let snapshotAt = snapshotAt { parameters["snapshotAt"] = snapshotAt }
            if let cursor = cursor { parameters["cursor"] = cursor }
            if let size = size { parameters["size"] = size }
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
