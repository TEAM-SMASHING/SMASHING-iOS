//
//  SearchUserAPI.swift
//  SMASHING
//
//  Created by 이승준 on 1/19/26.
//

import Foundation
import Moya

import Alamofire

enum SearchUserTarget {
    case searchUser(nickname: String)
}

extension SearchUserTarget: BaseTargetType {
    var path: String {
        switch self {
        case .searchUser:
            return "/api/v1/users/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchUser:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .searchUser(let nickname):
            // 쿼리 파라미터 ?nickname=ze 형태로 전달합니다.
            return .requestParameters(
                parameters: ["nickname": nickname],
                encoding: URLEncoding.queryString
            )
        }
    }
}
