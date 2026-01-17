//
//  SentRequestResultAPI.swift
//  SMASHING
//
//  Created by JIN on 1/17/26.
//

import Foundation

import Moya
import Alamofire

enum SentRequestResultAPI {
    case getSentRequestList(snapshotAt: String?, cursor: String?, size: Int?)
    case cancelSentRequest(matchingId: String)
}

extension SentRequestResultAPI: BaseTargetType {

    var path: String {
        switch self {
        case .getSentRequestList:
            return "api/v1/users/me/matchings/sent"
        case .cancelSentRequest(let matchingId):
            return "api/v1/users/me/matchings/\(matchingId)/cancel"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getSentRequestList:
            return .get
        case .cancelSentRequest:
            return .patch
        }
    }

    var task: Moya.Task {
        switch self {
        case .getSentRequestList(let snapshotAt, let cursor, let size):
            var parameters: [String: Any] = [:]
            if let snapshotAt = snapshotAt { parameters["snapshotAt"] = snapshotAt }
            if let cursor = cursor { parameters["cursor"] = cursor }
            if let size = size { parameters["size"] = size }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .cancelSentRequest:
            return .requestPlain
        }
    }
}
