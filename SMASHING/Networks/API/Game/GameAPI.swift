//
//  GameAPI.swift
//  SMASHING
//
//  Created by 홍준범 on 1/18/26.
//

import Alamofire
import Moya

enum GameAPI {
    case submissionResult(gameId: String, request: GameFirstSubmissionRequestDTO)
    case resubmission(gameId: String, request: GameResubmissionRequestDTO)
    case submissionConfirm(gameId: String, submissionId: String, request: GameConfirmRequestDTO)
    case rejectSubmission(gameId: String, submissionId: String, request: GameRejectRequestDTO)
    case deleteMatchBeforeConfirm //진재
    case seeSubmission(gameId: String, submissionId: String)
}

extension GameAPI: BaseTargetType {
    var path: String {
        switch self {
        case .submissionResult(let gameId, _), .resubmission(let gameId, _):
            return "/api/v1/games/\(gameId)/submissions"
        case .submissionConfirm(let gameId, let submissionId, _):
            return "/api/v1/games/\(gameId)/submissions/\(submissionId)/confirm"
        case .rejectSubmission(let gameId, let submissionId, _):
            return "/api/v1/games/\(gameId)/submissions/\(submissionId)/reject"
        case .deleteMatchBeforeConfirm:
            return "/api/v1/games/{gameId}"
        case .seeSubmission(let gameId, let submissionId):
            return "/api/v1/games/\(gameId)/submissions/\(submissionId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .submissionResult, .resubmission, .submissionConfirm, .rejectSubmission:
            return .post
        case .deleteMatchBeforeConfirm:
            return .put
        case .seeSubmission:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .submissionResult(_, let request):
            return .requestJSONEncodable(request)
        case .resubmission(_, let request):
            return .requestJSONEncodable(request)
        case .submissionConfirm(_, _, let request):
            return .requestJSONEncodable(request)
        case .rejectSubmission(_, _, let request):
            return .requestJSONEncodable(request)
        default:
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
