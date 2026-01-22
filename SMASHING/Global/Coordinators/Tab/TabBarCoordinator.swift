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
    
    var controllers: [UIViewController] = []
    let factory = DefaultTabBarFlowFactory()
    let tabBarController = MainTabBarController()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }

    func start() {
        MainTabBarController.Tab.allCases.forEach { tab in
            let (coordinator, navController) = factory.makeTabFlow(for: tab)
            
            if let homeCoordinator = coordinator as? HomeCoordinator {
                homeCoordinator.navAction = { [weak self] nav in
                    guard let self else { return }
                    switch nav {
                    case .navConfirmedMatchManage:
                        tabBarController.selectedIndex = 2
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.goToMatchManage(index: 0)
                        }
                        print("100")
                    case .navRequestedMatchManage:
                        tabBarController.selectedIndex = 2
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.goToMatchManage(index: 2)
                        }
                        print("200")
                    case .navSearchUser:
                        tabBarController.selectedIndex = 1
                        print("300")
                    }
                }
            }
            
            MainTabBarController.setupTabBarItem(for: navController, with: tab)
            
            childCoordinators.append(coordinator)
            controllers.append(navController)
            
            coordinator.start()
        }
        
        tabBarController.viewControllers = controllers
        
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(tabBarController, animated: false)
    }
    
    func goToMatchManage(index: Int) {
        guard let navVC = tabBarController.viewControllers?[2] as? UINavigationController,
              let matchingManageVC = navVC.viewControllers.first as? MatchingManageViewController else {
            return
        }
        if index == 0 {
            matchingManageVC.moveToPage(tab: .received)
        } else if index == 2 {
            matchingManageVC.moveToPage(tab: .confirmed)
        }
    }

    
}
