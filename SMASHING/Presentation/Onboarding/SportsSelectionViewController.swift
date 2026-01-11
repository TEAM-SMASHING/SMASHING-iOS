//
//  SportsSelectionViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/9/26.
//

import UIKit

import SnapKit
import Then

final class SportsSelectionViewController: BaseViewController {
    
    // MARK: - Properties
        
    private let sportsView = SportsSelectionView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = sportsView
        view.backgroundColor = .clear
    }
    
    // MARK: - Setup Methods
    
    func configure(action: @escaping (Sports) -> Void) {
        sportsView.configure(action: action)
    }
}
