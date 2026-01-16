//
//  OnboardingCoordinator.swift
//  SMASHING
//
//  Created by 이승준 on 1/16/26.
//

import UIKit

final class OnboardingCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.childCoordinators = []
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = OnboardingViewModel()
        let viewController = OnboardingViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
