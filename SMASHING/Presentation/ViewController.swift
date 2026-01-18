//
//  ViewController.swift
//  SMASHING
//
//  Created by 이승준 on 12/28/25.
//

import UIKit

import SnapKit
import Then

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Background.overlay
        
        self.hideKeyboardWhenDidTap()
    }
}

import SwiftUI
@available(iOS 18.0, *)
#Preview {
    ViewController()
}
