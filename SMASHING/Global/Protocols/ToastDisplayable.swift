//
//  ToastDisplayable.swift
//  SMASHING
//
//  Created by 이승준 on 1/22/26.
//

import UIKit

protocol ToastDisplayable: AnyObject {
    func showToast(type: NotificationType, completion: @escaping () -> Void)
}

extension ToastDisplayable where Self: UIViewController {
    func showToast(type: NotificationType) {
        let toast = ToastMessage()
        self.view.addSubview(toast)
        
        toast.configure(title: type.displayText) {
            toast.removeFromSuperview()
        }
        
        toast.show()
    }
}
