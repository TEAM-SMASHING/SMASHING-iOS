//
//  ProfileCoordinator.swift
//  Coordinator-Pattern
//
//  Created by 이승준 on 1/10/26.
//

import Combine
import UIKit

import Then

final class ProfileCoordinator: Coordinator {

    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    
    var cancellables: Set<AnyCancellable> = []

    init(navigationController: UINavigationController) {
        self.childCoordinators = []
        self.navigationController = navigationController
    }

    func start() {
        let profileService = UserProfileService()
        let reviewService = UserReviewService()
        let viewModel = MyProfileViewModel(userProfileService: profileService, userReviewService: reviewService)
        let viewController = MyProfileViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
        
        viewModel.output.navigateToAddSports.sink { [weak self] in
            
        }
        .store(in: &cancellables)
        
        
        viewModel.output.navToSeeAllReviews.sink { [weak self] in
            self?.showAllReviews()
        }
        .store(in: &cancellables)
        
        viewModel.output.navToTierExplanation.sink { [weak self] in
            self?.TierExplanation()
        }
        .store(in: &cancellables)
    }
    
    func showAddSports() {
        
    }
    
    func showAllReviews() {
        let myReviewCoordinator = MyReviewCoordinator(navigationController: navigationController)
        childCoordinators.append(myReviewCoordinator)
        myReviewCoordinator.start()
    }
    
    func TierExplanation() {
        let tierViewController = TierExplanationViewController(sports: .badminton, oreTier: .bronze)
        tierViewController.dismissAction = { [weak self] in
            self?.navigationController.dismiss(animated: true)
        }
        navigationController.present(tierViewController, animated: true)
    }
}
