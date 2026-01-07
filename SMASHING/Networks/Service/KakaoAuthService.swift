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

protocol KakaoAuthServiceProtocol {
    func login() -> AnyPublisher<KakaoLoginDataDTO, NetworkError>
}

final class KakaoAuthService: KakaoAuthServiceProtocol {
    func login() -> AnyPublisher<KakaoLoginDataDTO, NetworkError> {
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
    
    private func loginToServer(accessToken: String) -> AnyPublisher<KakaoLoginDataDTO, NetworkError> {
        return NetworkProvider<KakaoAuthAPI>
            .requestPublisher(.login(accessToken: accessToken), type: KakaoLoginResponseDTO.self)
            .map { response in
                return response.data
            }
            .eraseToAnyPublisher()
    }
}
