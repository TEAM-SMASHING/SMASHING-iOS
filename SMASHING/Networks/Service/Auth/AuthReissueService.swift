//
//  AuthReissueService.swift
//  SMASHING
//

import Combine

protocol AuthReissueServiceType {
    func reissue(refreshToken: String) -> AnyPublisher<Bool, Never>
}

final class AuthReissueService: AuthReissueServiceType {
    /// refreshToken으로 새 accessToken 발급 시도
    /// - 성공 시 Keychain에 새 accessToken 저장 후 true 반환
    /// - 실패 시 false 반환
    func reissue(refreshToken: String) -> AnyPublisher<Bool, Never> {
        NetworkProvider<AuthReissueAPI>
            .requestPublisher(.reissue(refreshToken: refreshToken), type: AuthReissueDataDTO.self)
            .handleEvents(receiveOutput: { response in
                _ = KeychainService.add(key: Environment.accessTokenKey, value: response.data.accessToken)
            })
            .map { _ in true }
            .catch { _ in Just(false) }
            .eraseToAnyPublisher()
    }
}
