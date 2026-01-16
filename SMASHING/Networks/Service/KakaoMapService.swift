//
//  KakaoMapService.swift
//  SMASHING
//
//  Created by 이승준 on 1/5/26.
//

import Combine
import Foundation

protocol KakaoMapServiceProtocol {
    func searchAddress(query: String) -> AnyPublisher<KakaoAddressResponseDTO, NetworkError>
}

final class KakaoMapService: KakaoMapServiceProtocol {
    func searchAddress(query: String) -> AnyPublisher<KakaoAddressResponseDTO, NetworkError> {
        return NetworkProvider<KakaoMapAPI>
            .requestPublisher(
                .searchAddress(query: query),
                type: KakaoAddressResponseDTO.self
            )
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
