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
    func showNotification(transition: CATransition?)
    func presentToast(notificationType: NotificationType)
}

extension Coordinator {
    
    func showNotification(transition: CATransition? = nil) {
        if let transition = transition {
            navigationController.viewControllers.last?.view.layer.add(transition, forKey: nil)
        }
        navigationController.viewControllers.last?
            .present(NotificationViewController(), animated: true)
    }
    
    func presentToast(notificationType: NotificationType) {
        let toast = ToastMessage()
        navigationController.viewControllers.last?.view.addSubview(toast)
        
        toast.configure(title: notificationType.displayText, action: { [weak self] in

            guard let self = self else { return }
            
            let transition = CATransition().then {
                $0.duration = 0.3
                $0.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                $0.type = .moveIn
                $0.subtype = .fromTop
            }
            
            showNotification(transition: transition)
            
            toast.removeFromSuperview()
        })
        toast.show()
    }
}
