//
//  RegionService.swift
//  SMASHING
//
//  Created by 홍준범 on 1/17/26.
//

import Foundation
import Combine

protocol RegionServiceProtocol {
    func getRecommendedUsers() -> AnyPublisher<RecommendedUserResponseDTO, NetworkError>
    func getLocalRanking() -> AnyPublisher<RankingResponseDTO, NetworkError>
    func getLocalUsers()
}

final class RegionService: RegionServiceProtocol {
    func getRecommendedUsers() -> AnyPublisher<RecommendedUserResponseDTO, NetworkError> {
        return NetworkProvider<RegionAPI>
            .requestPublisher(.getRecommendedUsers, type: RecommendedUserResponseDTO.self)
            .map { response in
                response.data
            }
            .eraseToAnyPublisher()
    }
    
    func getLocalRanking() -> AnyPublisher<RankingResponseDTO, NetworkError> {
        return NetworkProvider<RegionAPI>
            .requestPublisher(.getLocalRanking, type: RankingResponseDTO.self)
            .map { response in
                response.data
            }
            .eraseToAnyPublisher()
    }
    
    func getLocalUsers() {
        
    }
}
