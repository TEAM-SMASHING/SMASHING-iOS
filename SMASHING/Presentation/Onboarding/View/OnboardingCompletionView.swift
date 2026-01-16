//
//  OnboardingCompletion.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class OnboardingCompletionView: BaseUIView {
    
    // MARK: - Properties
    
    private var action: (() -> Void)?
    
    // MARK: - UI Properties
    
    private let containerView = UIView()
    
    private let checkedButtonImageView = UIImageView().then {
        $0.image = .checkButtonChecked
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "환영합니다!"
        $0.textColor = .Text.primary
        $0.font = .pretendard(.headerHeroB)
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "스매싱과 함께 동네 최강이 되어봐요!"
        $0.textColor = .Text.secondary
        $0.font = .pretendard(.textMdM)
    }
    
    private lazy var checkButton = CTAButton(label: "완료", action: self.action)
    
    // MARK: - Setup Methods
    
    override func setUI() {
        addSubviews(containerView, checkButton)
        
        containerView.addSubviews(checkedButtonImageView, titleLabel, subtitleLabel)
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-50)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        checkedButtonImageView.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.top.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(checkedButtonImageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        checkButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(18)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func configure(action: (() -> Void)? ) {
        self.action = action
    }
}
