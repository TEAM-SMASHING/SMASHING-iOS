//
//  ProfileCoordinator.swift
//  Coordinator-Pattern
//
//  Created by 이승준 on 1/10/26.
//

import UIKit

final class ProfileCoordinator: Coordinator {

    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.childCoordinators = []
        self.navigationController = navigationController
    }

    func start() {
        let profileService = UserProfileService()
        let reviewService = UserReviewService()
        let viewModel = MyProfileViewModel(userProfileService: profileService, userReviewService: reviewService)
        navigationController
            .pushViewController(MyProfileViewController(viewModel: viewModel), animated: true)
    }
}

// MockUserReviewService.swift

import Combine
import Foundation

// MockUserReviewService.swift

import Combine
import Foundation

final class MockUserReviewService: UserReviewServiceProtocol {
    
    // 상단 카드 요약 데이터 Mock
    func fetchMyReviewSummary() -> AnyPublisher<ReviewSummaryResponse, NetworkError> {
        let mockSummary = ReviewSummaryResponse(
            ratingCounts: RatingCounts(best: 5, good: 4, bad: 10),
            tagCounts: TagCounts(goodManner: 3, onTime: 2, fairPlay: 5, fastResponse: 1)
        )
        
        return Just(mockSummary)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }

    // 하단 최근 리뷰 리스트 Mock
    func fetchMyRecentReviews(size: Int, cursor: String?) -> AnyPublisher<RecentReviewResponse, NetworkError> {
        let mockResults = [
            RecentReviewResult(
                gameReviewId: "1",
                opponentNickname: "닝우닝",
                createdAt: "2일 전",
                content: "매너도 좋고, 너무 잘하세요!"
            ),
            RecentReviewResult(
                gameReviewId: "2",
                opponentNickname: "닝우닝닝이",
                createdAt: "4일 전",
                content: "매너도 좋고, 너무 잘하세요!"
            ),
            RecentReviewResult(
                gameReviewId: "3",
                opponentNickname: "닝우",
                createdAt: "5일 전",
                content: "매너도 좋고, 너무 잘하세요! 매너도 좋고, 너무 잘하세요! 매너도 좋고, 너무 잘하세요!"
            )
        ]
        
        let response = RecentReviewResponse(
            snapshotAt: "2026-01-20T17:40:00",
            results: mockResults,
            nextCursor: nil,
            hasNext: false
        )
        
        return Just(response)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }

    // 나머지 프로토콜 준수
    func fetchOtherUserRecentReviews(userId: String, sport: Sports, size: Int, cursor: String?) -> AnyPublisher<RecentReviewResponse, NetworkError> {
        return Empty().eraseToAnyPublisher()
    }

    func fetchOtherUserReviewSummary(userId: String, sport: Sports) -> AnyPublisher<ReviewSummaryResponse, NetworkError> {
        return Empty().eraseToAnyPublisher()
    }
}
