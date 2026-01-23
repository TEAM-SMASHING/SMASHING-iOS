//
//  OnboardingCoordinator.swift
//  SMASHING
//
//  Created by 이승준 on 1/16/26.
//

import Combine
import UIKit

final class OnboardingCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    var cancellables: Set<AnyCancellable> = []
    
    var confirmAction: (() -> Void)?
    
    private weak var onboardingViewController: OnboardingViewController?

    init(navigationController: UINavigationController) {
        self.childCoordinators = []
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = OnboardingViewModel()
        let viewController = OnboardingViewController(viewModel: viewModel)
        self.onboardingViewController = viewController
        
        viewModel.output.navAddressPushEvent
            .sink { [weak self] in
                guard let self else { return }
                pushAddressFlow()
            }
            .store(in: &cancellables)
        
        viewModel.output.navPushToOnboardingCompletionEvent
            .sink { [weak self] in
                guard let self else { return }
                pushToOnboardingCompletion()
            }
            .store(in: &cancellables)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func pushAddressFlow() {
        let addressCoordinator = AddressCoordinator(navigationController: navigationController, mode: .onboarding)
        childCoordinators.append(addressCoordinator)
        
        addressCoordinator.backAction = { [weak self, weak addressCoordinator] address in
            guard let self = self, let coordinator = addressCoordinator else { return }
            
            self.onboardingViewController?.updateSelectedAddress(address)
            self.navigationController.popViewController(animated: true)
            self.childCoordinators.removeAll { $0 === coordinator }
        }
        
        addressCoordinator.start()
    }
    
    private func pushToOnboardingCompletion() {
        let onboardingCompletionViewController = OnboardingCompletionViewController()
        navigationController.pushViewController(onboardingCompletionViewController, animated: true)
        onboardingCompletionViewController.nextAction = { [weak self] in
            guard let self else { return }
            confirmAction?()
        }
    }
}
