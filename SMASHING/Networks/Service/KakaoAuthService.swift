//
//  KakaoAuthService.swift
//  SMASHING
//
//  Created by 홍준범 on 1/6/26.
//

import Foundation
import Combine

import KakaoSDKUser
import KakaoSDKAuth

enum KakaoLoginResult {
    case needSignUp(authId: String)
    case success(accessToken: String, refreshToken: String, authId: String)
}

protocol KakaoAuthServiceProtocol {
    func login() -> AnyPublisher<KakaoLoginResult, NetworkError>
}

final class KakaoAuthService: KakaoAuthServiceProtocol {
    func login() -> AnyPublisher<KakaoLoginResult, NetworkError> {
        return loginWithKakaoSDK()
            .flatMap { accessToken in
                self.loginToServer(accessToken: accessToken)
            }
            .eraseToAnyPublisher()
    }
    
    private func loginWithKakaoSDK() -> AnyPublisher<String, NetworkError> {
        return Future<String, NetworkError> { promise in
            if UserApi.isKakaoTalkLoginAvailable() {
                self.loginWithApp(completion: promise)
            } else {
                self.loginWithAccount(completion: promise)
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func loginWithApp(completion: @escaping (Result<String, NetworkError>) -> Void) {
        UserApi.shared.loginWithKakaoTalk { oauthToken, error in
            if let error = error {
                completion(.failure(.networkFail))
            } else if let token = oauthToken {
                completion(.success(token.accessToken))
            }
        }
    }
    
    private func loginWithAccount(completion: @escaping (Result<String, NetworkError>) -> Void) {
        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
            if let error = error {
                completion(.failure(.networkFail))
            } else if let token = oauthToken {
                completion(.success(token.accessToken))
            }
        }
    }
    
    private func loginToServer(accessToken: String) -> AnyPublisher<KakaoLoginResult, NetworkError> {
        return NetworkProvider<KakaoAuthAPI>
            .requestPublisher(.login(accessToken: accessToken), type: KakaoLoginDataDTO.self)
            .tryMap { response in
                let data = response.data
                if response.statusCode == 202 {
                    guard data.accessToken == nil, data.refreshToken == nil else {
                        throw NetworkError.decoding
                    }
                    return .needSignUp(authId: data.userId ?? "")
                } else if response.statusCode == 200 {
                    guard let accessToken = data.accessToken,
                          let refreshToken = data.refreshToken else {
                        throw NetworkError.decoding
                    }
                    return .success(accessToken: accessToken, refreshToken: refreshToken, authId: data.userId ?? "")
                } else {
                    throw NetworkError.networkFail
                }
            }
            .mapError { error in
                return error as? NetworkError ?? .networkFail
            }
            .eraseToAnyPublisher()
    }
}
