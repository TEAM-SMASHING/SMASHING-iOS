//
//  KakaoAuthResponseDTO.swift
//  SMASHING
//
//  Created by 홍준범 on 1/6/26.
//

import Foundation

// MARK: - Login Response
struct KakaoLoginResponseDTO: Decodable {
    let status: String
    let statusCode: Int
    let data: KakaoLoginDataDTO
    let timestamp: String
}

struct KakaoLoginDataDTO: Decodable {
    let accessToken: String?
    let refreshToken: String?
    let authId: String
}

// MARK: - Error Response
struct KakaoAuthErrorDTO: Decodable {
    let status: String
    let statusCode: Int
    let message: String
    let errorCode: String
    let errorName: String
    let timestamp: String
}
