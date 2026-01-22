//
//  SearchMatchCoordinator.swift
//  Coordinator-Pattern
//
//  Created by 이승준 on 1/10/26.
//

import UIKit

final class MatchingSearchCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.childCoordinators = []
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = MatchingSearchViewModel(service: MatchingSearchService())
        let matchingSearchVC = MatchingSearchViewController(viewModel: viewModel)
        matchingSearchVC.onSearchTapped = { [weak self] in
            self?.showSearchResult()
        }
        matchingSearchVC.onUserSelected = { [weak self] userId in
            self?.showUserProfile(userId: userId)
        }
        navigationController.pushViewController(matchingSearchVC, animated: true)
    }

    private func showSearchResult() {
        let searchVC = SearchResultViewController()
        navigationController.pushViewController(searchVC, animated: true)
    }

    private func showUserProfile(userId: String) {
        let viewModel = UserProfileViewModel(userId: userId, sport: currentUserSport())
        let userProfileVC = UserProfileViewController(viewModel: viewModel)
        navigationController.pushViewController(userProfileVC, animated: true)
    }

    private func currentUserSport() -> Sports {
        guard let userId = KeychainService.get(key: Environment.userIdKey), !userId.isEmpty else {
            return .badminton
        }

        let key = "\(Environment.sportsCodeKeyPrefix).\(userId)"
        let rawValue = KeychainService.get(key: key)
        guard let rawValue,
              let sport = Sports(rawValue: rawValue) else {
            return .badminton
        }

        return sport
    }
}
