//
//  OpenChatCheckView.swift
//  SMASHING
//
//  Created by 이승준 on 1/11/26.
//

import UIKit

import SnapKit
import Then

final class OpenChatCheckView: BaseUIView {

    // MARK: - UI Components
    
    let textField = CommonTextField().then {
        $0.placeholder = "오픈채팅 링크를 입력해주세요"
    }

    // MARK: - Setup Methods
    
    override func setUI() {
        addSubviews(textField)
    }
    
    override func setLayout() {
        textField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
    }
    
}
