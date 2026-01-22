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
    var onExperienceSelected: ((ExperienceRange) -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = tierSelectionView
        tierSelectionView.configure { [weak self] experience in
            self?.onExperienceSelected?(experience)
        }
    }
}
