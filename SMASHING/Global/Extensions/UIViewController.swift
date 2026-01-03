//
//  UIViewController.swift
//  SMASHING
//
//  Created by 이승준 on 12/29/25.
//

import UIKit

extension UIViewController {
    /// 화면 터치시 키보드를 내리는 함수입니다
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
