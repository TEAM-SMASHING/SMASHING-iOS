//
//  OpenChatCheckViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/9/26.
//

import UIKit

import SnapKit
import Then

final class OpenChatCheckViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let openChatCheckView = OpenChatCheckView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = openChatCheckView
    }
}
