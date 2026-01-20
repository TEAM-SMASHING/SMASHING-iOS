//
//  KakaoAPI.swift
//  SMASHING
//
//  Created by 이승준 on 1/5/26.
//

import Foundation

import Alamofire
import Moya

enum KakaoAddressAPI {
    case searchAddress(query: String, analyzeType: String = "similar", page: Int = 1, size: Int = 10)
}

extension KakaoAddressAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://dapi.kakao.com/v2/local")!
    }

    var path: String {
        return "/search/address.JSON"
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case .searchAddress(let query, let analyzeType, let page, let size):
            let parameters: [String: Any] = [
                "query": query,
                "analyze_type": analyzeType,
                "page": page,
                "size": size
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return [
            "Authorization": "KakaoAK \(Environment.kakaoRESTAPIKey)",
            "Content-Type": "application/json"
        ]
    }

    var sampleData: Data {
        return Data()
    }
}
