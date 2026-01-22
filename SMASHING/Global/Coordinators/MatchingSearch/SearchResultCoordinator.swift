//
//  SearchResultCoordinator.swift
//  Coordinator-Pattern
//
//  Created by JIN on 1/22/26.
//

import Combine
import UIKit

final class SearchResultCoordinator: Coordinator {

    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    private var cancellables: Set<AnyCancellable> = []

    private let userSportProvider: UserSportProviding

    init(navigationController: UINavigationController, userSportProvider: UserSportProviding) {
        self.childCoordinators = []
        self.navigationController = navigationController
        self.userSportProvider = userSportProvider
    }

    func start() {
        let viewModel = SearchResultViewModel()
        let viewController = SearchResultViewController(viewModel: viewModel)

        viewModel.navigationEvent.userSelected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userId in
                self?.showUserProfile(userId: userId)
            }
            .store(in: &cancellables)

        navigationController.pushViewController(viewController, animated: true)
    }

    private func showUserProfile(userId: String) {
        let viewModel = UserProfileViewModel(userId: userId, sport: userSportProvider.currentSport())
        let userProfileVC = UserProfileViewController(viewModel: viewModel)
        navigationController.pushViewController(userProfileVC, animated: true)
    }
}
