//
//  SentRequestResultAPI.swift
//  SMASHING
//
//  Created by JIN on 1/17/26.
//

import UIKit

import Moya
import Alamofire

enum SentRequestResultAPI {
    case getSentRequestResult
    case cancelSentRequest(resultId: String)
}

extension SentRequestResultAPI {
    
    var path: String {
        switch self {
        case.getSentRequestResult:
            return "api/v1/sent-requests"
        case .cancelSentRequest:
            return "api/v1/sent-requests"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case.getSentRequestResult:
            return .get
        case .cancelSentRequest:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getSentRequestResult:
            return .requestPlain
        case .cancelSentRequest(resultId: let resultId):
            return .requestPlain
        }
    }
}
