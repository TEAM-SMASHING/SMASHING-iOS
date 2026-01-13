//
//  MyReviewsViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class MyReviewsViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let myReviewsView: MyReviewsView = MyReviewsView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        view = myReviewsView
    }
    
}

import SwiftUI
@available(iOS 18.0, *)
#Preview {
    MyReviewsViewController()
}
