//
//  MatchResultCreateSecondViewController.swift
//  SMASHING
//
//  Created by 홍준범 on 1/13/26.
//

import UIKit

import Then
import SnapKit

final class ReviewCreateViewController: BaseViewController {
    
    private let mainView = ReviewCreateView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Background.canvas
    }
}
