//
//  DefaultTabBarSceneFactory.swift
//  Coordinator-Pattern
//
//  Created by 이승준 on 1/8/26.
//

import UIKit

protocol TabBarFlowFactory {
    func makeTabFlow(for tab: MainTabBarController.Tab) -> (Coordinator, UINavigationController)
}

final class DefaultTabBarFlowFactory: TabBarFlowFactory {
    func makeTabFlow(for tab: MainTabBarController.Tab) -> (any Coordinator, UINavigationController) {
        switch tab {
        case .home:
            let navController = UINavigationController()
            return (HomeCoordinator(navigationController: navController), navController)
        case .matchingSearch:
            let navController = UINavigationController()
            let userSportsProvider = KeychainUserSportProvider()
            return (
                MatchingSearchCoordinator(
                    navigationController: navController,
                    userSportProvider: userSportsProvider
                ),
                navController
            )
        case .matchingManage:
            let navController = UINavigationController()
            return (MatchingManageCoordinator(navigationController: navController), navController)
        case .profile:
            let navController = UINavigationController()
            return (ProfileCoordinator(navigationController: navController), navController)
        }
    }
}
