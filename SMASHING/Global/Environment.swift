//
//  Environment.swift
//  Smashing-Assignment
//
//  Created by 이승준 on 12/30/25.
//

import Foundation

enum Environment {
    static let baseURL: String = Bundle.main.infoDictionary?["BaseURL"] as! String
    static let kakaoAPPKey: String = Bundle.main.infoDictionary?["KAKAO_APP_Key"] as! String
    static let kakaoRESTAPIKey: String = Bundle.main.infoDictionary?["KAKAO_REST_API_Key"] as! String
    
    static let accessTokenKey: String = "accessToken"
    static let refreshTokenKey: String = "refreshToken"
    static let kakaoId: String = "kakaoId"
    static let userIdKey: String = "userId"
    static let nicknameKey: String = "nicknameKey"
    static let sportsCodeKeyPrefix: String = "sportsCode"
}
