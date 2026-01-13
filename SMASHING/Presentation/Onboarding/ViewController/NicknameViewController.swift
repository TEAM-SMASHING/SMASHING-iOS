//
//  NicknameViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/9/26.
//

import UIKit

import SnapKit
import Then

final class NicknameViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let nicknameView = NicknameView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        view = nicknameView
    }
}
