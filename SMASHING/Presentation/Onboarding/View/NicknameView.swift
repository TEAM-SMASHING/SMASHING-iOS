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

    // MARK: - Properties
    private let maxNicknameLength = 10

    // MARK: - UI Components

    let nicknameTextField = CommonTextField().then {
        $0.hideClearButtonAlways()
        $0.placeholder = "닉네임을 입력해주세요"
    }
    
    private let countLabel = UILabel().then {
        $0.text = "0/10"
        $0.font = .pretendard(.captionXsR)
        $0.textColor = .Text.disabled
    }
 
    // MARK: - Setup Methods

    override func setUI() {
        addSubviews(nicknameTextField, countLabel)
        nicknameTextField.delegate = self
    }

    override func setLayout() {
        nicknameTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        countLabel.snp.makeConstraints {
            $0.centerY.equalTo(nicknameTextField)
            $0.trailing.equalTo(nicknameTextField).offset(-16)
        }
        
        nicknameTextField.addPadding(left: 16, right: 50)
    }
    
    private func updateCountLabel(count: Int) {
        countLabel.text = "\(count)/\(maxNicknameLength)"
    }
}

// MARK: - UITextFieldDelegate

extension NicknameView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            nicknameTextField.resetToDefault()
            return true
        }

        let pattern = "^[a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣]*$"
        if string.range(of: pattern, options: .regularExpression) == nil {
            nicknameTextField.setError(message: "한글, 영어, 숫자만 입력 가능합니다.")
            return false
        }

        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        if updatedText.count > maxNicknameLength {
            return false
        }

        nicknameTextField.resetToDefault()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let count = textField.text?.count ?? 0
        updateCountLabel(count: count)
    }
}
