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
    
    var action: ((NotificationAction) -> Void)?
    private var cancellables: Set<AnyCancellable> = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        let service = NotificationService()
        let viewModel = NotificationViewModel(service: service)
        let viewController = NotificationListViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
        
        viewModel.output.navConfirmedMatchManage.sink { [weak self] in
            self?.action?(.navConfirmedMatchManage)
        }
        .store(in: &cancellables)
        
        viewModel.output.navRequestedMatchManage.sink { [weak self] in
            self?.action?(.navRequestedMatchManage)
        }
        .store(in: &cancellables)
        
        viewModel.output.navPop.sink { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        .store(in: &cancellables)
    }
}
