//
//  SearchResultCoordinator.swift
//  Coordinator-Pattern
//
//  Created by JIN on 1/22/26.
//

import Combine
import UIKit

final class SearchResultCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    private var cancellables: Set<AnyCancellable> = []
    private let userSportProvider: UserSportProviding

    init(navigationController: UINavigationController, userSportProvider: UserSportProviding) {
        self.userSportProvider = userSportProvider
        super.init(navigationController: navigationController)
    }

    override func start() {
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
        viewModel.output.navToMatchManage
            .receive(on: DispatchQueue.main)
            .sink { _ in
                NavigationManager.shared.navigateToMatchManageSentAndRefresh()
            }
            .store(in: &cancellables)
        navigationController.pushViewController(userProfileVC, animated: true)
    }
}
