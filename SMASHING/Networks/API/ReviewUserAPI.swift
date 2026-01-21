//
//  ReviewUserAPI.swift
//  SMASHING
//
//  Created by 이승준 on 1/19/26.
//

import Alamofire
import Moya

enum ReviewUserAPI {
    case getMyReviewSummary
    case getMyRecentReviews(size: Int, cursor: String?)
    case getOtherUserRecentReviews(userId: String, sport: Sports, size: Int, cursor: String?)
    case getOtherUserReviewSummary(userId: String, sport: Sports)
}

extension ReviewUserAPI: BaseTargetType {
    var path: String {
        switch self {
        case .getMyReviewSummary:
            return "/api/v1/users/me/reviews/summary"
        case .getMyRecentReviews:
            return "/api/v1/users/me/reviews/recent"
        case .getOtherUserRecentReviews(let userId, _, _, _):
            return "/api/v1/users/\(userId)/reviews/recent"
        case .getOtherUserReviewSummary(let userId, _):
            return "/api/v1/users/\(userId)/reviews/summary"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .getMyReviewSummary:
            return .requestPlain
        case .getMyRecentReviews(let size, let cursor):
            var params: [String: Any] = ["size": size]
            if let cursor = cursor {
                params["cursor"] = cursor
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getOtherUserRecentReviews(_, let sport, let size, let cursor):
            var params: [String: Any] = [
                "sportCode": sport.rawValue,
                "size": size
            ]
            if let cursor = cursor { params["cursor"] = cursor }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getOtherUserReviewSummary(_, let sport):
            return .requestParameters(
                parameters: ["sportCode": sport.rawValue],
                encoding: URLEncoding.queryString
            )
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
