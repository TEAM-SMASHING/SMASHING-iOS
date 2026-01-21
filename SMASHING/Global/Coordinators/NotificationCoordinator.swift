//
//  NotificationCoordinator.swift
//  SMASHING
//
//  Created by 이승준 on 1/21/26.
//

import Combine
import Foundation
import UIKit

final class NotificationCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        let service = NotificationService()
        let viewModel = NotificationViewModel(service: service)
        let viewController = NotificationViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
