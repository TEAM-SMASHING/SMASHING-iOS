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
        navigationController.pushViewController(matchingSearchVC, animated: true)
    }

    private func showSearchResult() {
        let searchVC = SearchResultViewController()
        navigationController.pushViewController(searchVC, animated: true)
    }
}
