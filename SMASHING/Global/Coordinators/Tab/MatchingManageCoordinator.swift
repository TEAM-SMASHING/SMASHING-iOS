//
//  ManageMatchCoordinator.swift
//  Coordinator-Pattern
//
//  Created by 이승준 on 1/10/26.
//

import UIKit

final class MatchingManageCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []

    override func start() {
        navigationController.pushViewController(MatchingManageViewController(), animated: true)
    }
}
