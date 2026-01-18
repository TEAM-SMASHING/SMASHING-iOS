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
        navigationController.pushViewController(OnboardingViewController(), animated: true)
    }
}
