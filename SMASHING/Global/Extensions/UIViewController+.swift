//
//  UIViewController.swift
//  SMASHING
//
//  Created by 이승준 on 12/29/25.
//

import UIKit
import Combine

extension UIViewController {
    
    func hideKeyboardWhenDidTap(cancelsTouches cancelsTouchesInView : Bool = false) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = cancelsTouchesInView
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    func bindKeyboardToSafeArea() -> AnyCancellable {
        let willChange = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillChangeFrameNotification)
        let willHide = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
        
        return willChange
            .merge(with: willHide)
            .receive(on: RunLoop.main)
            .sink { [weak self] notification in
                guard
                    let self,
                    let userInfo = notification.userInfo,
                    let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                    let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
                    let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
                else { return }
                
                let keyboardFrame = self.view.convert(endFrame, from: nil)
                let isHiding = notification.name == UIResponder.keyboardWillHideNotification
                let safeBottom = self.view.safeAreaInsets.bottom
                let overlap = isHiding ? 0 : max(0, self.view.bounds.maxY - keyboardFrame.minY - safeBottom)
                
                let options = UIView.AnimationOptions(rawValue: curveRaw << 16)
                UIView.animate(withDuration: duration, delay: 0, options: options) {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -overlap)
                }
            }
    }
}
