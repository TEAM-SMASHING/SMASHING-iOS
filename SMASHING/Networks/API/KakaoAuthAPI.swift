//
//  KakaoAuthAPI.swift
//  SMASHING
//
//  Created by 홍준범 on 1/6/26.
//

import Foundation

import Moya
import Alamofire

enum KakaoAuthAPI {
    case login(accessToken: String)
}

extension KakaoAuthAPI: BaseTargetType {
    var path: String {
        switch self {
        case .login:
            return "/api/v1/auth/login/kakao"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let accessToken):
            let parameters = [
                "accessToken": accessToken
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
}
