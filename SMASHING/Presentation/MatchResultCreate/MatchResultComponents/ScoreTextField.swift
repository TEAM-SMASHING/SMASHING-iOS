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
    
    private let maxLength = 2
    
    var onDone: (() -> Void)?
    
    private let defaultBorderColor: UIColor = .clear
    private let typingBorderColor: UIColor = .Border.typing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupToolbar()
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
        
        self.delegate = self
        
        self.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(40)
        }
    }
    
    private func setupToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonDidTap))
        
        toolbar.items = [flexSpace, doneButton]
        self.inputAccessoryView = toolbar
    }
    
    @objc
    private func doneButtonDidTap() {
        self.resignFirstResponder()
        onDone?()
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

extension ScoreTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty { return true }
        if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil { return false }
        let current = textField.text ?? ""
        guard let textRange = Range(range, in: current) else { return false }
        let updated = current.replacingCharacters(in: textRange, with: string)
        return updated.count <= maxLength
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        onDone?()
    }
}
