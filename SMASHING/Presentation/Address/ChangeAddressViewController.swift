//
//  ChangeAddressViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

import UIKit

final class ChangeAddressViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let mainView = ChangeAddressView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        self.view = mainView
    }
}
