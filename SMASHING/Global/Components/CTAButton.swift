//
//  CTAButton.swift
//  SMASHING
//
//  Created by 이승준 on 1/7/26.
//

import UIKit

import SnapKit
import Then

final class CTAButton: UIButton {
    
    // MARK: - Properties
    
    private var action: (() -> Void)?
    
    // MARK: - Init
    
    init(label: String, action: (() -> Void)? = nil) {
        self.action = action
        super.init(frame: .zero)
        
        setAttributes(label: label)
        setLayout()
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setAttributes(label: String) {
        self.setTitle(label, for: .normal)
        self.titleLabel?.font = .pretendard(.subtitleLgSb)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        
        updateStateAppearance()
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(46)
        }
    }
    
    // MARK: - UI Update Methods
    
    private func updateStateAppearance() {
        if !isEnabled {             // Disabled
            self.backgroundColor = UIColor(red: 34/255, green: 37/255, blue: 41/255, alpha: 1.0)
            self.setTitleColor(UIColor(red: 75/255, green: 80/255, blue: 89/255, alpha: 1.0), for: .normal)
        } else if isHighlighted {   // Pressed
            self.backgroundColor = UIColor(red: 54/255, green: 58/255, blue: 67/255, alpha: 1.0)
            self.setTitleColor(.white, for: .normal)
        } else {                    // Active
            self.backgroundColor = .white
            self.setTitleColor(.black, for: .normal)
        }
    }
    
    // MARK: - Overrides
    
    override var isEnabled: Bool {
        didSet { updateStateAppearance() }
    }
    
    override var isHighlighted: Bool {
        didSet { updateStateAppearance() }
    }
    
    // MARK: - Actions
    
    @objc private func buttonTapped() {
        action?()
    }
}
