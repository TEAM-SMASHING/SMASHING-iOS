//
//  SearchTextField.swift
//  SMASHING
//
//  Created by 이승준 on 1/7/26.
//

import UIKit

import SnapKit
import Then

final class SearchTextField: UITextField {
    
    // MARK: - Properties
    
    private let placeholderColor: UIColor = .Border.secondary
    
    // MARK: - UI Components

    private let leftIconView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .icSearchSm.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .Icon.secondary
    }
    
    private lazy var clearButton = UIButton().then {
        $0.isHidden = true
        $0.contentMode = .scaleAspectFit
        $0.setImage(.icCircleX, for: .normal)
        $0.isHidden = true
        $0.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .Background.surface
        textColor = .Text.primary
        
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
        self.leftViewMode = .always
        
        addSubviews(leftIconView, clearButton)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(46)
        }
        
        leftIconView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
            $0.leading.equalToSuperview().offset(16)
        }
        
        clearButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    private func setTarget() {
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func configure() {
        self.font = .pretendard(.textSmM)
        
        clipsToBounds = true
        layer.cornerRadius = 8
        
        self.isEnabled = true
        
        tintColor = .white
        autocorrectionType = .no
        spellCheckingType = .no
        
        defaultMode()
    }
    
    // MARK: - Actions
    
    @objc private func textFieldDidChange() {
        updateLeftIconState()
    }
    
    @objc private func clearButtonTapped() {
        self.text = ""
        updateLeftIconState()
        
        self.sendActions(for: .editingChanged)
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: self)
        
        self.becomeFirstResponder()
    }
    
    // MARK: - Private Methods
    
    private func updateLeftIconState() {
        if self.text?.isEmpty ?? true {
            defaultMode()
        } else {
            editingMode()
        }
    }
    
    private func defaultMode() {
        leftIconView.isHidden = false
        clearButton.isHidden = true
        addPadding(left: 16 + 24 + 4, right: 16)
    }
    
    private func editingMode() {
        leftIconView.isHidden = true
        clearButton.isHidden = false
        addPadding(left: 16, right: 16 + 24 + 16)
    }
    
    // MARK: - Public Methods
    
    func setPlaceholder(text: String) {
        self.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [.foregroundColor: placeholderColor]
        )
    }

}
