//
//  ProfileCoordinator.swift
//  Coordinator-Pattern
//
//  Created by 이승준 on 1/10/26.
//

import UIKit

import Then

final class ProfileCoordinator: Coordinator {

    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.childCoordinators = []
        self.navigationController = navigationController
    }

    func start() {
        let profileService = UserProfileService()
        let reviewService = UserReviewService()
        let viewModel = MyProfileViewModel(userProfileService: profileService, userReviewService: reviewService)
        let viewController = MyProfileViewController(viewModel: viewModel).then {
            $0.navigationController?.isNavigationBarHidden = true
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}
