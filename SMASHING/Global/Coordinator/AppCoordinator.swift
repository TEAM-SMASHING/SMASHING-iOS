//
//  Coordinator.swift
//  Coordinator-Pattern
//
//  Created by 이승준 on 1/10/26.
//

import Combine
import UIKit

final class AppCoordinator {
    var navigationController: UINavigationController

    private let authReissueService: AuthReissueServiceType
    private var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController,
         authReissueService: AuthReissueServiceType = AuthReissueService()) {
        self.navigationController = navigationController
        self.authReissueService = authReissueService
    }

    func start() {
        showSplashFlow()
    }

    func showSplashFlow() {
        let splashVC = SplashViewController()
        NavigationManager.shared.resetRootFlow(to: [splashVC])

        // 1초 후 자동 로그인 시도 → 결과에 따라 화면 전환
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.attemptAutoLogin()
        }
    }

    private func attemptAutoLogin() {
        guard let refreshToken = KeychainService.get(key: Environment.refreshTokenKey) else {
            showLoginFlow()
            return
        }
        authReissueService.reissue(refreshToken: refreshToken)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] success in
                if success {
                    self?.showTabBarFlow()
                } else {
                    self?.showLoginFlow()
                }
            }
            .store(in: &cancellables)
    }

    func showLoginFlow() {
        let loginVC = LoginViewController()
        loginVC.onNeedOnboarding = { [weak self] in self?.showOnboardingFlow() }
        loginVC.onLoginSuccess = { [weak self] in self?.showTabBarFlow() }
        // animated push 대신 즉시 루트로 설정 → 검은 화면 플래시 제거
        NavigationManager.shared.resetRootFlow(to: [loginVC])
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
