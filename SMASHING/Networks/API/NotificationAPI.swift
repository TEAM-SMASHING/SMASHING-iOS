//
//  NotificationTarget.swift
//  SMASHING
//
//  Created by 이승준 on 1/21/26.
//

import Alamofire
import Moya

enum NotificationTarget {
    case getNotifications(size: Int, cursor: String?, snapshotAt: String?)
    case readNotification(notificationId: String)
}

extension NotificationTarget: BaseTargetType {
    var path: String {
        switch self {
        case .getNotifications:
            return "/api/v1/notifications/me"
        case .readNotification(let notificationId):
            return "/api/v1/notifications/\(notificationId)/read"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getNotifications:
            return .get
        case .readNotification:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .getNotifications(let size, let cursor, let snapshotAt):
            var params: [String: Any] = ["size": size]
            if let cursor = cursor { params["cursor"] = cursor }
            if let snapshotAt = snapshotAt { params["snapshotAt"] = snapshotAt }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .readNotification:
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
