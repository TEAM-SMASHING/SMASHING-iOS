//
//  KakaoAuthResponseDTO.swift
//  SMASHING
//
//  Created by 홍준범 on 1/6/26.
//

import Foundation

struct KakaoLoginDataDTO: Decodable {
    let accessToken: String?
    let refreshToken: String?
    let kakaoId: String
    let userId: String?
    let nickname: String?
    let isCompletedSignUp: Bool
}

struct KakaoAuthErrorDTO: Decodable {
    let status: String
    let statusCode: Int
    let message: String
    let errorCode: String
    let errorName: String
    let timestamp: String
}
