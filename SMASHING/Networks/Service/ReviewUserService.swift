//
//  ReviewUserService.swift
//  SMASHING
//
//  Created by 이승준 on 1/19/26.
//

import Foundation

import Combine
import Foundation

protocol ReviewUserServiceType {
    func fetchMyReviewSummary() -> AnyPublisher<ReviewSummaryResponse, NetworkError>
    func fetchMyRecentReviews(size: Int, cursor: String?) -> AnyPublisher<RecentReviewResponse, NetworkError>
    func fetchOtherUserRecentReviews(userId: String, sport: Sports, size: Int, cursor: String?) -> AnyPublisher<RecentReviewResponse, NetworkError>
    func fetchOtherUserReviewSummary(userId: String, sport: Sports) -> AnyPublisher<ReviewSummaryResponse, NetworkError>
}

final class ReviewUserService: ReviewUserServiceType {
    func fetchMyReviewSummary() -> AnyPublisher<ReviewSummaryResponse, NetworkError> {
        return NetworkProvider<ReviewUserTarget>
            .requestPublisher(.getMyReviewSummary, type: ReviewSummaryResponse.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }

    func fetchMyRecentReviews(size: Int, cursor: String?) -> AnyPublisher<RecentReviewResponse, NetworkError> {
        return NetworkProvider<ReviewUserTarget>
            .requestPublisher(.getMyRecentReviews(size: size, cursor: cursor), type: RecentReviewResponse.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }

    func fetchOtherUserRecentReviews(userId: String, sport: Sports, size: Int, cursor: String?) -> AnyPublisher<RecentReviewResponse, NetworkError> {
        return NetworkProvider<ReviewUserTarget>
            .requestPublisher(.getOtherUserRecentReviews(userId: userId, sport: sport, size: size, cursor: cursor), type: RecentReviewResponse.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }

    func fetchOtherUserReviewSummary(userId: String, sport: Sports) -> AnyPublisher<ReviewSummaryResponse, NetworkError> {
        return NetworkProvider<ReviewUserTarget>
            .requestPublisher(.getOtherUserReviewSummary(userId: userId, sport: sport), type: ReviewSummaryResponse.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
