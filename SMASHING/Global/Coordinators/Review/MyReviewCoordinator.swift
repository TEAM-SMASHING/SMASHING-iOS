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
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        let service = UserReviewService()
        let viewModel = MyReviewsViewModel(service: service)
        let viewController = MyReviewsViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
        
        viewModel.output
            .navBack
            .sink { [weak self] _ in
                self?.navigationController.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
}
