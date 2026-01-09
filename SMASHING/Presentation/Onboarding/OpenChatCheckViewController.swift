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
        view.backgroundColor = .clear
    }
    
}

final class OpenChatCheckView: BaseUIView {
    
    // MARK: - Properties

    // MARK: - UI Components
    let textField = CommonTextField().then {
        $0.placeholder = "오픈채팅 링크를 입력해주세요"
    }

    // MARK: - Setup Methods
    // baseUIView/VC의 메소드 override 할때 setUI(), setLayout(), addTarget()
    override func setUI() {
        addSubviews(textField)
    }
    
    override func setLayout() {
        textField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
    }
    
}

