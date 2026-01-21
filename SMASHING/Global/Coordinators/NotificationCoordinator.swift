//
//  NotificationCoordinator.swift
//  SMASHING
//
//  Created by 이승준 on 1/21/26.
//

import Combine
import Foundation
import UIKit

enum NotificationAction {
    case navConfirmedMatchManage, navRequestedMatchManage
}

final class NotificationCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    
    var action: ((NotificationAction) -> Void)?
    private var cancellables: Set<AnyCancellable> = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        let service = MockNotificationService()
        let viewModel = NotificationViewModel(service: service)
        let viewController = NotificationViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
        
        viewModel.output.navConfirmedMatchManage.sink { [weak self] in
            print("navConfirmedMatchManage")
            self?.action?(.navConfirmedMatchManage)
            self?.navigationController.popViewController(animated: true)
        }
        .store(in: &cancellables)
        
        viewModel.output.navRequestedMatchManage.sink { [weak self] in
            print("navRequestedMatchManage")
            self?.action?(.navRequestedMatchManage)
            self?.navigationController.popViewController(animated: true)
        }
        .store(in: &cancellables)
    }
}
