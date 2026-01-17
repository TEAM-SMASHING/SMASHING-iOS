//
//  AddressCoordinator.swift
//  SMASHING
//
//  Created by 이승준 on 1/18/26.
//

import UIKit

final class AddressCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.childCoordinators = []
        self.navigationController = navigationController
    }

    func start() {
        let service = KakaoAddressService()
        let viewModel = AddressSearchViewModel(addressService: service)
        let viewController = AddressSearchViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

