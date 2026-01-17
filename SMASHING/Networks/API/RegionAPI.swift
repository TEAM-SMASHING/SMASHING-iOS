//
//  RegionAPI.swift
//  SMASHING
//
//  Created by 홍준범 on 1/17/26.
//

import Foundation

import Moya
import Alamofire

enum RegionAPI {
    case getRecommendedUsers
    case getLocalRanking
    case getLocalUsers(cursor: String?, size: Int?, gender: String?, tier: Int?)
}

extension RegionAPI: BaseTargetType {
    var path: String {
        switch self {
        case .getRecommendedUsers:
            return "/api/v1/users/regions/recommendation"
        case .getLocalRanking:
            return "/api/v1/users/me/regions/leaderboard"
        case .getLocalUsers:
            return "/api/v1/users/me/regions/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getRecommendedUsers, .getLocalRanking, .getLocalUsers:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getRecommendedUsers, .getLocalRanking:
            return .requestPlain
        case .getLocalUsers(let cursor, let size, let gender, let tier):
            var parameters: [String: Any] = [:]
            if let cursor = cursor { parameters["cursor"] = cursor }
            if let size = size { parameters["size"] = size }
            if let gender = gender { parameters["gender"] = gender }
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
