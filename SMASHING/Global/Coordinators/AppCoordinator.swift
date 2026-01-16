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
        showLoginFlow()
    }
    
    // 로그인 플로우 시작
    private func showLoginFlow() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        
        // 클로저를 통해 다음 단계 연결
        loginCoordinator.finishWithOnboarding = { [weak self] in
            self?.removeChildCoordinator(loginCoordinator)
            self?.showOnboardingFlow()
        }
        
        loginCoordinator.finishWithTabBar = { [weak self] in
            self?.removeChildCoordinator(loginCoordinator)
            self?.showTabBarFlow()
        }
        
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
    
    private func showOnboardingFlow() {
        navigationController.viewControllers.removeAll()
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    private func showTabBarFlow() {
        navigationController.viewControllers.removeAll()
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
    
    private func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
