//
//  BlueCTAButton.swift
//  SMASHING
//
//  Created by 이승준 on 1/7/26.
//

import UIKit

import SnapKit
import Then

final class BlueCTAButton: UIButton {
    
    // MARK: - Properties
    
    private var action: (() -> Void)?
    
    // MARK: - Setup Methods
    
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
    
    private func setAttributes(label: String) {
        self.setTitle(label, for: .normal)
        self.titleLabel?.font = .pretendard(.textMdSb)
        
        self.backgroundColor = .Tier.diamondBackground
        self.setTitleColor(.Text.emphasis, for: .normal)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(46)
        }
    }
    
    // MARK: - Actions
    
    @objc private func buttonTapped() {
        action?()
    }
}
