//
//  SignOutViewController.swift
//  SMASHING
//
//  Created by 이승준 on 3/8/26.
//

import UIKit

final class SignOutViewController: BaseViewController {
    
    let signOutView = SignOutView()
    
    override func loadView() {
        view = signOutView
    }
    
}
