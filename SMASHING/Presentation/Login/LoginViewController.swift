//
//  LoginViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/12/26.
//

import UIKit

final class LoginViewController: BaseViewController {
    
    private let mainView = LoginView()
    
    override func viewDidLoad() {
        view = mainView
        view.backgroundColor = .Background.canvas
    }
}
