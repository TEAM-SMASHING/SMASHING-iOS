//
//  ProfileUserAPI.swift
//  SMASHING
//
//  Created by 이승준 on 1/19/26.
//

import Alamofire
import Moya

enum ProfileUserAPI {
    case getMyProfileTier
    case getMyProfiles
    case createProfile(request: CreateProfileRequest)
    case updateActiveProfile(request: UpdateActiveProfileRequest)
    case getOtherUserProfile(userId: String, sportCode: Sports)
    case updateRegion(region: String)
}

extension ProfileUserAPI: BaseTargetType {
    var path: String {
        switch self {
        case .getMyProfileTier:
            return "/api/v1/users/me/profiles/tier"
        case .getMyProfiles:
            return "/api/v1/users/me/profiles"
        case .createProfile:
            return "/api/v1/users/me/profiles"
        case .updateActiveProfile:
            return "/api/v1/users/me/active-profile"
        case .getOtherUserProfile(let userId, _):
            return "/api/v1/users/\(userId)/profiles"
        case .updateRegion:
            return "/api/v1/users/me/regions"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .updateRegion: return .put
        case .createProfile: return .post
        case .updateActiveProfile: return .put
        default: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getOtherUserProfile(_, let sportCode):
            return .requestParameters(
                parameters: ["sportCode": sportCode.rawValue],
                encoding: URLEncoding.queryString
            )
        case .getMyProfiles: return .requestPlain
        case .getMyProfileTier:
            return .requestPlain
        case .createProfile(let request):
            return .requestJSONEncodable(request)
        case .updateActiveProfile(let request):
            return .requestJSONEncodable(request)
        case .updateRegion(let region):
            let request = UpdateRegionRequest(region: region)
            return .requestJSONEncodable(request)
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
