//
//  LoginCoordinator.swift
//  SMASHING
//
//  Created by 이승준 on 1/16/26.
//

import Combine
import UIKit

final class LoginCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private var cancellables: Set<AnyCancellable> = []

    // 완료 시 호출될 클로저 추가
    var finishWithOnboarding: (() -> Void)?
    var finishWithTabBar: (() -> Void)?

    override func start() {
        let kakaoAuthService = KakaoAuthService()
        let viewModel = LoginViewModel(kakaoAuthService: kakaoAuthService)
        let viewController = LoginViewController(viewModel: viewModel)
        bind(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    private func bind(viewModel: LoginViewModel) {
        viewModel.navigationEvent.onboardingEvent
            .sink { [weak self] in
                self?.showOnboardingCoordinatorFlow()
            }
            .store(in: &cancellables)

        viewModel.navigationEvent.tabBarEvent
            .sink { [weak self] in
                self?.showMainFlow()
            }
            .store(in: &cancellables)
    }

    private func showOnboardingCoordinatorFlow() {
        finishWithOnboarding?()
    }

    private func showMainFlow() {
        finishWithTabBar?()
    }
}
