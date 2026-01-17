//
//  AddressCoordinator.swift
//  SMASHING
//
//  Created by 이승준 on 1/18/26.
//

import Combine
import UIKit

final class AddressCoordinator: Coordinator {

    var backAction: ((String) -> Void)?

    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController

    var cancellables: Set<AnyCancellable> = []

    init(navigationController: UINavigationController) {
        self.childCoordinators = []
        self.navigationController = navigationController
    }

    func start() {
        let service = KakaoAddressService()
        let viewModel = AddressSearchViewModel(addressService: service)
        let viewController = AddressSearchViewController(viewModel: viewModel)
        
        viewModel.navigationEvent.backTapped.sink { [weak self] address in
            guard let self else { return }
            backAction?(address)
        }
        .store(in: &cancellables)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
