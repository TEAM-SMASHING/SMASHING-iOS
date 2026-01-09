//
//  NicknameViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/9/26.
//

import UIKit

import SnapKit
import Then

final class NicknameViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let nicknameView = NicknameView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        view = nicknameView
        view.backgroundColor = .clear
    }
}

final class NicknameView: BaseUIView {
    
    // MARK: - Properties
    
    private var action: (() -> Void)?

    // MARK: - UI Components
    
    let nicknameTextField = CommonTextField().then {
        $0.hideClearButtonAlways()
        $0.placeholder = "닉네임을 입력해주세요"
    }
    
    lazy var nicknameCheckButton = CTAButton(label: "중복확인").then {
        $0.titleLabel?.font = .pretendard(.textSmM)
        $0.isEnabled = true
        $0.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        addSubviews(nicknameTextField, nicknameCheckButton)
    }
    
    override func setLayout() {
        nicknameCheckButton.snp.makeConstraints {
            $0.width.equalTo(73)
            $0.top.trailing.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(nicknameCheckButton.snp.leading).offset(-10)
        }
    }
    
    func configure(action: (() -> Void)? = nil) {
        self.action = action
    }
    
    // MARK: - Actions
    
    @objc func checkButtonTapped() {
        // acrion?()
        // 성공한 경우
        nicknameTextField.setMessage(message: "사용 가능한 닉네임입니다")
        // + 키보드 해제
        
        nicknameTextField.setError(message: "이미 존재하는 닉네임이에요")
    }
}
