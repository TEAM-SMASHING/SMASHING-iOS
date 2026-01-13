//
//  SatisfactionButton.swift
//  SMASHING
//
//  Created by 홍준범 on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class SatisfactionButton: UIView {
    private let titleText: String
    
    var isSelectedState: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
    }
    
    let circleButton = UIButton().then {
        $0.backgroundColor = .Button.textPrimaryDisabled
        $0.layer.cornerRadius = 28
        $0.clipsToBounds = true
    }
    
    private let checkmark = UIImageView().then {
        $0.image = .icCheckLg
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    private let label = UILabel().then {
        $0.font = .pretendard(.textSmM)
        $0.textColor = .Text.tertiary
        $0.textAlignment = .center
    }
    
    init(title: String) {
        self.titleText = title
        super.init(frame: .zero)
        
        label.text = title
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        circleButton.addSubviews(checkmark)
        stackView.addArrangedSubviews(circleButton, label)
        addSubviews(stackView)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        circleButton.snp.makeConstraints {
            $0.size.equalTo(56)
        }
        
        checkmark.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
    
    private func updateAppearance() {
        if isSelectedState {
            circleButton.backgroundColor = .Button.backgroundSecondaryActive
            checkmark.isHidden = false
            label.textColor = .Text.primary
        } else {
            circleButton.backgroundColor = .Button.textPrimaryDisabled
            checkmark.isHidden = true
            label.textColor = .Text.disabled
        }
    }
    
    func setSelected(_ selected: Bool) {
        isSelectedState = selected
    }
}
