//
//  ReviewService.swift
//  SMASHING
//
//  Created by 홍준범 on 1/22/26.
//

import Foundation
import Combine

protocol ReviewServiceProtocol {
    func fetchReview(reviewId: String) -> AnyPublisher<ReviewDetailResponse, NetworkError>
}

final class ReviewService: ReviewServiceProtocol {
    
    func fetchReview(reviewId: String) -> AnyPublisher<ReviewDetailResponse, NetworkError> {
        return NetworkProvider<ReviewAPI>
            .requestPublisher(.getReview(reviewId: reviewId), type: ReviewDetailResponse.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
