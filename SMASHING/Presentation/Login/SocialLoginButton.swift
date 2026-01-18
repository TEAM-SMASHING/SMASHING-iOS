//
//  SocialLoginButton.swift
//  SMASHING
//
//  Created by 이승준 on 1/12/26.
//

import UIKit

import SnapKit
import Then

final class SocialLoginButton: UIButton {
    
    // MARK: - UI Components
    
    private let mainStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.isUserInteractionEnabled = false
    }
    
    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let iconLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .black
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(mainStack)
        
        mainStack.addArrangedSubviews(iconImageView, iconLabel)
    }
    
    private func setLayout() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        
        mainStack.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(18)
        }
    }
    
    func configure(logo: UIImage, title: String) {
        iconImageView.image = logo
        iconLabel.text = title
    }
}
