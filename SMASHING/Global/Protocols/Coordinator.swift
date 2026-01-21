//
//  Coordinator.swift
//  Coordinator-Pattern
//
//  Created by 이승준 on 1/10/26.
//

import UIKit

import Then

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}

extension Coordinator {
    func presentToast(notificationType: NotificationType) {
        guard let displayableVC = navigationController.visibleViewController as? ToastDisplayable else {
            return
        }
        
        displayableVC.showToast(type: notificationType) { [weak self] in
            
        }
    }
}
