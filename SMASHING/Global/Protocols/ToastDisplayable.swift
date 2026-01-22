//
//  ToastDisplayable.swift
//  SMASHING
//
//  Created by 이승준 on 1/22/26.
//

import UIKit

protocol ToastDisplayable: AnyObject {
    func showToast(type: SseEventType)
}
//
//extension ToastDisplayable where Self: UIViewController {
//    func showToast(type: SseEventType) {
//        let toast = ToastMessage()
//        self.view.addSubview(toast)
//        self.view.bringSubviewToFront(toast)
//        
//        toast.configure(title: type.rawValue) {
//            toast.removeFromSuperview()
//        }
//        
//        toast.show()
//    }
//}
