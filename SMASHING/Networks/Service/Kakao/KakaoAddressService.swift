//
//  KakaoMapService.swift
//  SMASHING
//
//  Created by 이승준 on 1/5/26.
//

import Combine

protocol KakaoAddressServiceProtocol {
    func searchAddress(query: String) -> AnyPublisher<KakaoAddressResponseDTO, NetworkError>
}

final class KakaoAddressService: KakaoAddressServiceProtocol {
    func searchAddress(query: String) -> AnyPublisher<KakaoAddressResponseDTO, NetworkError> {
        return NetworkProvider<KakaoAddressAPI>
            .plainRequestPublisher(.searchAddress(query: query),
                                          type: KakaoAddressResponseDTO.self)
            .eraseToAnyPublisher()
    }
}
