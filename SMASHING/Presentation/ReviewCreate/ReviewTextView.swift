//
//  ReviewTextView.swift
//  SMASHING
//
//  Created by 홍준범 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class ReviewTextView: BaseUIView {
    
    private let maxCharacterCount: Int = 100
    var text: String {
        return textView.text
    }
    
    private let textView = UITextView().then {
        $0.backgroundColor = .clear
        $0.font = .pretendard(.textSmR)
        $0.textColor = .Text.primary
        $0.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 40, right: 16)
        $0.textContainer.lineFragmentPadding = 0
    }
    
    private let placeholderLabel = UILabel().then {
        $0.text = "매칭 후기를 작성해주세요"
        $0.font = .pretendard(.textSmR)
        $0.textColor = .Text.tertiary
    }
    
    private let characterCountLabel = UILabel().then {
        $0.font = .pretendard(.captionXsR)
        $0.textColor = .Text.secondary
        $0.text = "0 / 100"
    }
    
    override func setUI() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.Border.secondary.cgColor
        
        textView.delegate = self
        
        addSubviews(textView, placeholderLabel, characterCountLabel)
    }
    
    override func setLayout() {
        textView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        characterCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    
    private func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    private func updateCharacterCount() {
        let count = textView.text.count
        characterCountLabel.text = "\(count) / \(maxCharacterCount)"
        
        if count > maxCharacterCount {
            characterCountLabel.textColor = .Text.red //border가 바뀌는걸로
            textView.layer.borderColor = UIColor.Border.error.cgColor
        } else {
            characterCountLabel.textColor = .Text.tertiary
        }
    }
}

extension ReviewTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderVisibility()
        updateCharacterCount()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in:  currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return updatedText.count <= maxCharacterCount
    }
}
