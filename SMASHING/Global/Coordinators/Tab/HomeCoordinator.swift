//
//  HomeCoordinator.swift
//  SMASHING
//
//  Created by 이승준 on 1/12/26.
//

import UIKit
import Combine

final class HomeCoordinator: Coordinator {

    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    private var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }

    func start() {
        let regionService = RegionService()
        let viewModel = HomeViewModel(regionService: regionService)
        let homeVC = HomeViewController(viewModel: viewModel)
        
        bindNavigationEvents(output: viewModel.output)
        navigationController.pushViewController(homeVC, animated: true)
    }
    
    private func bindNavigationEvents(output: HomeViewModel.Output) {
        output.navToRanking
            .sink { [weak self] in
                self?.showRanking()
            }
            .store(in: &cancellables)
    }
    
    private func showRanking() {
//        let regionService = RegionService()
//                let viewModel = RankingViewModel(regionService: regionService)
//                let rankingVC = RankingViewController(viewModel: viewModel)
        let rankingVC = RankingViewController()
        navigationController.pushViewController(rankingVC, animated: true)
    }
}
