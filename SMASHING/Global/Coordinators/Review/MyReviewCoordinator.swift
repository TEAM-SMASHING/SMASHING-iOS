//
//  MyReviewCoordinator.swift
//  SMASHING
//
//  Created by 이승준 on 1/21/26.
//

import Combine
import UIKit

final class MyReviewCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        let service = UserReviewService()
        let viewModel = MyReviewsViewModel(service: service)
        let viewController = MyReviewsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
