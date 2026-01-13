//
//  ScoreTextField.swift
//  SMASHING
//
//  Created by 홍준범 on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class ScoreTextField: UITextField {
    
    private let defaultBorderColor: UIColor = .clear
    private let typingBorderColor: UIColor = .Border.typing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.placeholder = "0"
        self.textAlignment = .center
        self.keyboardType = .numberPad
        self.font = .pretendard(.textSmM)
        self.textColor = .Text.primary
        self.backgroundColor = .Background.surface
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = defaultBorderColor.cgColor
        
        configurePlaceholderColor(.Text.disabled)
        
        self.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(40)
        }
    }
    
    private func configurePlaceholderColor(_ color: UIColor) {
        guard let placeholder = self.placeholder else { return }
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: color])
    }
    
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if result {
            self.layer.borderColor = typingBorderColor.cgColor
        }
        return result
    }
    
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        if result {
            self.layer.borderColor = defaultBorderColor.cgColor
        }
        return result
    }
}
