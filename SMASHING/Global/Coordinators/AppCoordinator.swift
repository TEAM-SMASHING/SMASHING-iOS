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
    
    private func showMyReviewFlow() {
        let reviewCoordinator = MyReviewCoordinator(navigationController: navigationController)
        childCoordinators.append(reviewCoordinator)
        reviewCoordinator.start()
    }
    
    private func showLoginFlow() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        
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
        
        onboardingCoordinator.confirmAction = { [weak self] in
            guard let self else { return }
            showTabBarFlow()
        }
    }
    
    private func showAddressFlow() {
        navigationController.viewControllers.removeAll()
        let addressCoordinator = AddressCoordinator(navigationController: navigationController, mode: .onboarding)
        childCoordinators.append(addressCoordinator)
        addressCoordinator.start()
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
    
    private func showNotificationFlow() {
        let notificationCoordinator = NotificationCoordinator(navigationController: navigationController)
        childCoordinators.append(notificationCoordinator)
        notificationCoordinator.start()
    }
}
