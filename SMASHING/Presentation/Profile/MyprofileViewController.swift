//
//  MyprofileViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class MyprofileViewController: UIViewController {
    
    // MARK: - Properties
    
    private let mainView = MyprofileView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        view = mainView
    }
    
}
