//
//  ProfileCoordinator.swift
//  Coordinator-Pattern
//
//  Created by 이승준 on 1/10/26.
//

import UIKit

final class ProfileCoordinator: Coordinator {

    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.childCoordinators = []
        self.navigationController = navigationController
    }

    func start() {
        let service = UserProfileService()
        let viewModel = MyProfileViewModel(userProfileService: service)
        navigationController
            .pushViewController(MyProfileViewController(viewModel: viewModel), animated: true)
    }
}
