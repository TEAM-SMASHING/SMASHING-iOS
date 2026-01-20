//
//  TierSelectionViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/9/26.
//

import Combine
import UIKit

import SnapKit
import Then

final class EditTierSelectionViewController: BaseViewController {
    
    let tierSelectionView = ExperienceSelectionView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = tierSelectionView
    }
}
