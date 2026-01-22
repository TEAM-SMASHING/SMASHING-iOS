//
//  ReviewAPI.swift
//  SMASHING
//
//  Created by 홍준범 on 1/22/26.
//

import Foundation

import Moya
import Alamofire

enum ReviewAPI {
    case getReview(reviewId: String)
}

extension ReviewAPI: BaseTargetType {
    var path: String {
        switch self {
        case .getReview(let reviewId ):
            return "/api/v1/reviews/\(reviewId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getReview:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getReview:
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
