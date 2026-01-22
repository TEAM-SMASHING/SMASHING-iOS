//
//  SearchMatchCoordinator.swift
//  Coordinator-Pattern
//
//  Created by 이승준 on 1/10/26.
//

import UIKit
import Combine

final class MatchingSearchCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    private let userSportProvider: UserSportProviding
    var cancellables: Set<AnyCancellable> = []
    let userProfileService = UserProfileService()
    
    var navAction: (() -> Void)?

    init(navigationController: UINavigationController, userSportProvider: UserSportProviding) {
        self.childCoordinators = []
        self.navigationController = navigationController
        self.userSportProvider = userSportProvider
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
        searchResultCoordinator.navToMatchManage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navAction?()
            }
            .store(in: &cancellables)
        childCoordinators.append(searchResultCoordinator)
        searchResultCoordinator.start()
    }
    
    private func showUserProfile(userId: String) {
        let viewModel = UserProfileViewModel(userId: userId, sport: userSportProvider.currentSport())
        let userProfileVC = UserProfileViewController(viewModel: viewModel)
        navigationController.pushViewController(userProfileVC, animated: true)
        
        viewModel.output.navToMatchManage.sink { [weak self] in
            self?.navAction?()
        }
        .store(in: &cancellables)
    }
    
    private func showRegionSelection() {
        let addressCoordinator = AddressCoordinator(navigationController: navigationController)
        childCoordinators.append(addressCoordinator)
        
        addressCoordinator.backAction = { [weak self, weak addressCoordinator] address in
            guard let self else { return }
            _ = KeychainService.add(key: Environment.regionKey, value: address)
            
            self.userProfileService.updateRegion(region: address)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { })
                .store(in: &self.cancellables)
            
            self.navigationController.popViewController(animated: true)
            if let coordinator = addressCoordinator {
                self.childCoordinators.removeAll { $0 === coordinator }
            }
        }
        
        addressCoordinator.start()
    }
}
