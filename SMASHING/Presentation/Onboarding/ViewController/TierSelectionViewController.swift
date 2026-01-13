//
//  TierSelectionViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/9/26.
//

import UIKit

import SnapKit
import Then

final class TierSelectionViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let selectionView = TierSelectionView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = selectionView
        view.backgroundColor = .clear
    }
    
    // MARK: - Setup Methods
    
    func configure(action: @escaping (Tier) -> Void) {
        selectionView.configure(action: action)
    }
}
