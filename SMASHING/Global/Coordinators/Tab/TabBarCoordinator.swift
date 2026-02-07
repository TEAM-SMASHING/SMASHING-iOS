//
//  TabBarCoordinator.swift
//  SMASHING
//
//  Created by 이승준 on 1/12/26.
//

import UIKit

final class TabBarCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []

    var controllers: [UIViewController] = []
    let factory = DefaultTabBarFlowFactory()
    let tabBarController = MainTabBarController()

    override func start() {
        NavigationManager.shared.setTabBarController(tabBarController)
        NavigationManager.shared.subscribeToSSEEvents()

        MainTabBarController.Tab.allCases.forEach { tab in
            let (coordinator, navController) = factory.makeTabFlow(for: tab)
            MainTabBarController.setupTabBarItem(for: navController, with: tab)
            childCoordinators.append(coordinator)
            controllers.append(navController)
            coordinator.start()
        }

        tabBarController.viewControllers = controllers
        NavigationManager.shared.setRootNavigationBarHidden(true)
        NavigationManager.shared.pushToRoot(tabBarController, animated: false)
    }
}
