//
//  AreaSelectionViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/9/26.
//

import UIKit

import SnapKit
import Then

final class AreaSelectionViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let areaSelectionView = AreaSelectionView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = areaSelectionView
    }
    
    func configure(action: @escaping () -> Void) {
        areaSelectionView.configure(action: action)
    }
}
