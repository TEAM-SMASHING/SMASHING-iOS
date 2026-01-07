//
//  CommonTextField.swift
//  SMASHING
//
//  Created by 이승준 on 1/7/26.
//

import UIKit

import SnapKit
import Then

final class CommonTextField: UITextField {
    
    // MARK: - Properties
    
    private let defaultBorderColor: UIColor = .Border.secondary
    private let highlightedBorderColor: UIColor = .Border.typing
    private let cursorColor: UIColor = .Border.secondary
    private let errorColor: UIColor = .Border.error
    private let placeholderColor: UIColor = .Border.secondary
    
    private var isClearButtonHidden: Bool = false
    
    // MARK: - UI Components
    
    private let errorStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
        $0.isHidden = true
    }
    
    private let errorIconView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .icWarning
    }
    
    private lazy var errorLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = self.errorColor
    }
    
    private let clearButton = UIButton().then {
        $0.contentMode = .scaleAspectFit
        $0.setImage(.icCircleX, for: .normal)
        $0.isHidden = true
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = cursorColor
        setPlaceholderColor(.Text.disabled)
        setUI()
        setLayout()
        setTarget()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setUI() {
        [clearButton, errorStackView].forEach { addSubview($0) }
        [errorIconView, errorLabel].forEach { errorStackView.addArrangedSubview($0) }
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(46)
        }
        
        clearButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        errorIconView.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
        
        errorStackView.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(4)
        }
    }
    
    private func setTarget() {
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
    }
    
    private func configure() {
        self.configureDefaultTextField()
        self.addPadding(left: 16, right: 16 + 24 + 16)
        
        self.font = .pretendard(.textSmM)
        self.textColor = .white
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1.0
        self.layer.borderColor = defaultBorderColor.cgColor
        
        self.backgroundColor = .clear
        self.clearButtonMode = .never
    }
    
    // MARK: - Actions
    
    @objc private func textFieldDidChange() {
        updateClearButtonVisibility()
    }
    
    @objc private func clearButtonTapped() {
        self.text = ""
        updateClearButtonVisibility()
        
        self.sendActions(for: .editingChanged)
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: self)
    }
    
    // MARK: - Private Methods
    
    private func updateClearButtonVisibility() {
        if isClearButtonHidden {
            clearButton.isHidden = true
            return
        }
        
        let hasText = !(self.text?.isEmpty ?? true)
        clearButton.isHidden = !hasText
    }
    
    // MARK: - Public Methods
    
    func setError(message: String?) {
        if let message = message {
            self.layer.borderColor = errorColor.cgColor
            errorLabel.text = message
            errorStackView.isHidden = false
        } else {
            resetToDefault()
        }
    }
    
    func resetToDefault() {
        self.layer.borderColor = self.isFirstResponder ? highlightedBorderColor.cgColor : defaultBorderColor.cgColor
        errorStackView.isHidden = true
    }
    
    func hideClearButtonAlways() {
        self.isClearButtonHidden = true
        updateClearButtonVisibility()
        self.addPadding(left: 16, right: 16)
    }
    
    func showClearButtonStandard() {
        self.isClearButtonHidden = false
        updateClearButtonVisibility()
        self.addPadding(left: 16, right: 56)
    }
    
    // MARK: - Extensions (Overrides)
    
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if result {
            self.layer.borderColor = highlightedBorderColor.cgColor
            updateClearButtonVisibility()
        }
        return result
    }
    
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        if result {
            self.layer.borderColor = defaultBorderColor.cgColor
            clearButton.isHidden = true
        }
        return result
    }
}
