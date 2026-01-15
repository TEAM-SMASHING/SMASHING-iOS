//
//  AppCoordinator.swift
//  Coordinator-Pattern
//
//  Created by 이승준 on 1/10/26.
//

import UIKit

final class AppCoordinator: Coordinator {

    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        let root = HomeViewController()
        navigationController.pushViewController(root, animated: false)
//        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
//        childCoordinators.append(tabBarCoordinator)
//        tabBarCoordinator.start()
    }
}
