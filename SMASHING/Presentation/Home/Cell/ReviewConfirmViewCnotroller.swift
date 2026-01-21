//
//  ReviewConfirmViewCnotroller.swift
//  SMASHING
//
//  Created by 홍준범 on 1/22/26.
//

import UIKit
import Combine

import SnapKit
import Then

final class ReviewConfirmViewCnotroller: BaseViewController {
    
    private let mainView = ReviewConfirmView()
    
    override func loadView() {
        view = mainView
    }
}

