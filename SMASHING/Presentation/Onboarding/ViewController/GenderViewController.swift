//
//  GenderViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/9/26.
//

import UIKit

import SnapKit
import Then

final class GenderViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let genderView = GenderView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = genderView
        view.backgroundColor = .clear
    }
    
    // MARK: - Setup Methods
    
    func configure(action: @escaping (Gender) -> Void) {
        genderView.configure(action: action)
    }
}
