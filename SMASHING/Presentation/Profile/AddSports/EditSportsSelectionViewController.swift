//
//  EditSportsSelectionViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/17/26.
//

import Combine
import UIKit

import SnapKit
import Then

final class EditSportsSelectionViewController: BaseViewController {
    
    // MARK: - Properties
        
    let sportsView = SportsSelectionView()
    var onSportSelected: ((Sports) -> Void)?
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = sportsView
        sportsView.configure { [weak self] sport in
            self?.onSportSelected?(sport)
        }
    }
}
