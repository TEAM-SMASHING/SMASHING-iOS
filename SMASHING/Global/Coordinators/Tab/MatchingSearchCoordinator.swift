//
//  SearchMatchCoordinator.swift
//  Coordinator-Pattern
//
//  Created by 이승준 on 1/10/26.
//

import UIKit
import Combine

final class MatchingSearchCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    private let userSportProvider: UserSportProviding
    var cancellables: Set<AnyCancellable> = []
    let userProfileService = UserProfileService()

    init(navigationController: UINavigationController, userSportProvider: UserSportProviding) {
        self.userSportProvider = userSportProvider
        super.init(navigationController: navigationController)
    }

    override func start() {
        let viewModel = MatchingSearchViewModel(service: MatchingSearchService())
        let matchingSearchVC = MatchingSearchViewController(viewModel: viewModel)
        matchingSearchVC.onSearchTapped = { [weak self] in
            self?.showSearchResult()
        }
        matchingSearchVC.onUserSelected = { [weak self] userId in
            self?.showUserProfile(userId: userId)
        }
        matchingSearchVC.onRegionTapped = { [weak self] in
            self?.showRegionSelection()
        }
        navigationController.pushViewController(matchingSearchVC, animated: true)
    }

    private func showSearchResult() {
        let searchResultCoordinator = SearchResultCoordinator(
            navigationController: navigationController,
            userSportProvider: userSportProvider
        )
        childCoordinators.append(searchResultCoordinator)
        searchResultCoordinator.start()
    }

    private func showUserProfile(userId: String) {
        let viewModel = UserProfileViewModel(userId: userId, sport: userSportProvider.currentSport())
        let userProfileVC = UserProfileViewController(viewModel: viewModel)
        navigationController.pushViewController(userProfileVC, animated: true)

        viewModel.output.navToMatchManage.sink { _ in
            NavigationManager.shared.navigateToMatchManageSentAndRefresh()
        }
        .store(in: &cancellables)
    }

    private func showRegionSelection() {
        let addressCoordinator = AddressCoordinator(
            navigationController: navigationController,
            mode: .changeRegion
        )

        childCoordinators.append(addressCoordinator)

        addressCoordinator.onAddressSelectedForRegionChange = { [weak self] address in
            guard let self else { return }

            UserDefaults.standard.set(address, forKey: UserDefaultKey.region)

            self.userProfileService.updateRegion(region: address)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    if case .failure(let err) = completion {
                        print("updateRegion 실패:", err)
                    }
                }, receiveValue: { _ in
                    print("updateRegion 성공:", address)
                })
                .store(in: &self.cancellables)
        }

        addressCoordinator.start()
    }
}
