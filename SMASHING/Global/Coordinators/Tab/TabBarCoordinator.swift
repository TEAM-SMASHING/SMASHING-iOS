//
//  TabBarCoordinator.swift
//  SMASHING
//
//  Created by 이승준 on 1/12/26.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }

    func start() {
        var controllers: [UIViewController] = []
        let factory = DefaultTabBarFlowFactory()

        MainTabBarController.Tab.allCases.forEach { tab in
            let (coordinator, navController) = factory.makeTabFlow(for: tab)
            
            MainTabBarController.setupTabBarItem(for: navController, with: tab)
            
            childCoordinators.append(coordinator)
            controllers.append(navController)
            
            coordinator.start()
        }

        let tabBarController = MainTabBarController()
        tabBarController.viewControllers = controllers
        
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(tabBarController, animated: false)
    }
}
