//
//  ProfileCard.swift
//  SMASHING
//
//  Created by 이승준 on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class ProfileCard: BaseUIView {
    
    // MARK: - Properties
    
    var challengeAction: (() -> Void)?
    
    // MARK: - UI Componetns
    
    private let containerView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let profileImage = UIImageView().then {
        $0.backgroundColor = .Background.overlay
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 30
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "하나둘셋넷다여칠팔구"
        $0.font = .pretendard(.subtitleLgSb)
        $0.textColor = .Text.primary
    }
    
    private let genderIcon = UIImageView().then {
        $0.image = .icWomanSm.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .Icon.primary
        $0.contentMode = .scaleAspectFit
    }
    
    private let tierIcon = UIImageView().then {
        $0.image = .tierBronzeStage1
        $0.contentMode = .scaleAspectFit
    }
    
    private let recordLabel = UILabel().then {
        $0.text = "전적"
        $0.font = .pretendard(.textMdM)
        $0.textColor = .Text.tertiary
    }
    
    private let reviewLabel = UILabel().then {
        $0.text = "후기"
        $0.font = .pretendard(.textMdM)
        $0.textColor = .Text.tertiary
    }
    
    private let winLoseRecordLabel = UILabel().then {
        $0.text = "0승 0패"
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.secondary
    }
    
    private let reviewCountsLabel = UILabel().then {
        $0.text = "32"
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.secondary
    }
    
    private lazy var challengeButton = CTAButton(label: "경쟁 신청하기").then {
        $0.addTarget(self, action: #selector(challengeButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        addSubview(containerView)
        containerView.addSubviews(profileImage, titleLabel, genderIcon, tierIcon,
                    recordLabel, reviewLabel, winLoseRecordLabel, reviewCountsLabel)
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.size.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage)
            $0.leading.equalTo(profileImage.snp.trailing).offset(12)
        }
        
        genderIcon.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
            $0.size.equalTo(20)
        }
        
        tierIcon.snp.makeConstraints {
            $0.bottom.equalTo(profileImage)
            $0.leading.equalTo(profileImage.snp.trailing).offset(12)
            $0.height.equalTo(24)
            $0.width.equalTo(67)
        }
        
        recordLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        winLoseRecordLabel.snp.makeConstraints {
            $0.centerY.equalTo(recordLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        reviewLabel.snp.makeConstraints {
            $0.top.equalTo(recordLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(16)
        }
        
        reviewCountsLabel.snp.makeConstraints {
            $0.centerY.equalTo(reviewLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    func addChallengeButton() {
        addSubview(challengeButton)
        challengeButton.snp.makeConstraints {
            $0.top.equalTo(reviewCountsLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func changeButtonState(isEnabled: Bool) {
        challengeButton.isEnabled = isEnabled
    }
    
    // MARK: - Actions
    
    @objc private func challengeButtonTapped() {
        challengeAction?()
    }
}
