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
        // 검은 화면 방지: 즉시 로그인 화면을 루트로 설정
        showLoginFlow()

        // refreshToken 존재 시 자동 로그인 시도
        guard let refreshToken = KeychainService.get(key: Environment.refreshTokenKey) else { return }
        authReissueService.reissue(refreshToken: refreshToken)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] success in
                if success { self?.showTabBarFlow() }
                // 실패 시 로그인 화면 그대로 유지
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
