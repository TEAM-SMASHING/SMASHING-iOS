//
//  NicknameView.swift
//  SMASHING
//
//  Created by 이승준 on 1/11/26.
//

import UIKit

import SnapKit
import Then

final class NicknameView: BaseUIView {

    // MARK: - UI Components

    let nicknameTextField = CommonTextField().then {
        $0.hideClearButtonAlways()
        $0.placeholder = "닉네임을 입력해주세요"
    }
 
    // MARK: - Setup Methods

    override func setUI() {
        addSubviews(nicknameTextField)
    }

    override func setLayout() {
        nicknameTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    
    
}
