//
//  MatchingRequestAPI.swift
//  SMASHING
//
//  Created by JIN on 1/22/26.
//

import Foundation

import Moya
import Alamofire

enum MatchingRequestAPI {
    case requestMatching(receiverProfileId: String)
}

extension MatchingRequestAPI: BaseTargetType {

    var path: String {
        switch self {
        case .requestMatching(let receiverProfileId):
            return "api/v1/matchings/profiles/\(receiverProfileId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .requestMatching:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .requestMatching:
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
