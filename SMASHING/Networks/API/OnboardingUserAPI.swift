//
//  UserAPI.swift
//  SMASHING
//
//  Created by 이승준 on 1/17/26.
//

import Alamofire
import Moya

enum OnboardingUserAPI {
    case checkNicknameAvailability(nickname: String)
    case validateOpenchatUrl(url: String)
    case signup(request: SignupRequestDTO)
}

extension OnboardingUserAPI: BaseTargetType {
    var path: String {
        switch self {
        case .checkNicknameAvailability:
            return "/api/v1/users/nickname-availability"
        case .validateOpenchatUrl:
            return "/api/v1/users/openchat/validate"
        case .signup:
            return "/api/v1/auth/signup"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkNicknameAvailability:
            return .get
        case .validateOpenchatUrl:
            return .post
        case .signup:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .checkNicknameAvailability(let nickname):
            return .requestParameters(
                parameters: ["nickname": nickname],
                encoding: URLEncoding.queryString
            )
        case .validateOpenchatUrl(let url):
            return .requestParameters(
                parameters: ["openchatUrl": url],
                encoding: JSONEncoding.default
            )
        case .signup(let request):
            return .requestJSONEncodable(request)
        }
    }
}
