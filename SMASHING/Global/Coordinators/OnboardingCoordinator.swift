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
    
    private weak var onboardingViewController: OnboardingViewController?

    init(navigationController: UINavigationController) {
        self.childCoordinators = []
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = OnboardingViewModel()
        let viewController = OnboardingViewController(viewModel: viewModel)
        self.onboardingViewController = viewController
        
        viewModel.navigationEvent.addressPushEvent.sink { [weak self] in
            guard let self else { return }
            pushAddressFlow()
        }
        .store(in: &cancellables)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func pushAddressFlow() {
        let addressCoordinator = AddressCoordinator(navigationController: navigationController)
        childCoordinators.append(addressCoordinator)
        
        addressCoordinator.backAction = { [weak self, weak addressCoordinator] address in
            guard let self = self, let coordinator = addressCoordinator else { return }
            
            self.onboardingViewController?.updateSelectedAddress(address)
            self.navigationController.popViewController(animated: true)
            self.childCoordinators.removeAll { $0 === coordinator }
        }
        
        addressCoordinator.start()
    }
}
