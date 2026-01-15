//
//  OnboardingCompletionViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

import UIKit

final class OnboardingCompletionViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let mainView = OnboardingCompletionView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        view = mainView
    }
}

