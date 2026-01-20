//
//  ReviewUserAPI.swift
//  SMASHING
//
//  Created by 이승준 on 1/19/26.
//

import Foundation

import Alamofire
import Moya

enum ReviewUserTarget {
    case getMyReviewSummary
    case getMyRecentReviews(size: Int, cursor: String?)
    case getOtherUserRecentReviews(userId: String, sport: Sports, size: Int, cursor: String?)
    case getOtherUserReviewSummary(userId: String, sport: Sports)
}

extension ReviewUserTarget: BaseTargetType {
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
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIwUDc1VjFSU0QyUkpSIiwidHlwZSI6IkFDQ0VTU19UT0tFTiIsInJvbGVzIjpbXSwiaWF0IjoxNzY4NzY3NzUzLCJleHAiOjEyMDk3NzY4NzY3NzUzfQ.IVEVsz0pOPYB2Lr0gNphh2IwxNZnQpLluWL1n3melug"
        ]
    }
}
