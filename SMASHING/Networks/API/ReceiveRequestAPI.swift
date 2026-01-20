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
    case acceptRequest(matchingId: String)
    case rejectRequest(matchingID: String)
}

extension ReceiveRequestAPI: BaseTargetType {

    var path: String {
        switch self {
        case .getReceivedRequestList:
            return "api/v1/users/me/matchings/received"
        case .acceptRequest(let matchingId):
            return "api/v1/matchings/\(matchingId)/accept"
        case .rejectRequest(let matchingId):
            return "api/v1/matchings/\(matchingId)/reject"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getReceivedRequestList:
            return .get
        case .acceptRequest:
            return .post
        case .rejectRequest:
            return .post
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
        case .acceptRequest:
            return .requestPlain
        case .rejectRequest:
            return .requestPlain
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
