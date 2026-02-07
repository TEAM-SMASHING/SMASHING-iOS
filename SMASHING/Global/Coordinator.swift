//
//  Coordinator.swift
//  Coordinator-Pattern
//
//  Created by 이승준 on 1/10/26.
//

import Combine
import UIKit

class Coordinator {
    var navigationController: UINavigationController
    private var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showLoginFlow()
    }

    func showLoginFlow() {
        let loginVC = LoginViewController()
        loginVC.onNeedOnboarding = { [weak self] in self?.showOnboardingFlow() }
        loginVC.onLoginSuccess = { [weak self] in self?.showTabBarFlow() }
        NavigationManager.shared.pushToRoot(loginVC)
    }

    func showOnboardingFlow() {
        NavigationManager.shared.resetRootFlow(to: [])
        let onboardingVC = OnboardingViewController()
        onboardingVC.onComplete = { [weak self] in self?.showTabBarFlow() }
        NavigationManager.shared.pushToRoot(onboardingVC)
    }

    func showTabBarFlow() {
        NavigationManager.shared.resetRootFlow(to: [])
        NavigationManager.shared.setupTabBar()
    }
}
