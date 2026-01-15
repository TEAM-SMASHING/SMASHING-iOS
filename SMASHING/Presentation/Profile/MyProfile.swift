//
//  MyProfile.swift
//  SMASHING
//
//  Created by 이승준 on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class MyprofileView: BaseUIView {
    
    // MARK: - UI Components
    
    private let navigationBar = CustomNavigationBar(title: "프로필").then {
        $0.setLeftButtonHidden(true)
    }
    
    private let profileCard = ProfileCard().then {
        $0.addChallengeButton()
    }
    
    private let winRateCard = WinRateCard()
    
    private let reviewCard = ReviewCard()
    
    
    // MARK: - Setup Methods
    
    override func setUI() {
        addSubviews(navigationBar, profileCard, winRateCard, reviewCard)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        profileCard.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(222)
        }
        
        winRateCard.snp.makeConstraints {
            $0.top.equalTo(profileCard.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        reviewCard.snp.makeConstraints {
            $0.top.equalTo(winRateCard.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(100)
        }
    }
}

final class ProfileCard: BaseUIView {
    
    // MARK: - Properties
    
    // MARK: - UI Componetns
    
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
        addSubviews(profileImage, titleLabel, genderIcon, tierIcon,
                    recordLabel, reviewLabel, winLoseRecordLabel, reviewCountsLabel)
    }
    
    override func setLayout() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        self.backgroundColor = .Background.surface
        
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
    
    // MARK: - Actions
    
    @objc private func challengeButtonTapped() {
        
    }
}

final class TierCard: BaseUIView {
    
}

import UIKit

import SnapKit
import Then

final class WinRateCard: BaseUIView {
    
    // MARK: - UI Components
    
    private let containerView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let mainStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .center
    }
    
    private let winStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 4
    }
    
    private let winCountLabel = UILabel().then {
        $0.text = "12"
        $0.font = .pretendard(.titleXlSb)
        $0.textColor = .Text.emphasis
    }
    
    private let winTitleLabel = UILabel().then {
        $0.text = "승리"
        $0.font = .pretendard(.captionXsM)
        $0.textColor = .white
    }
    
    private let loseStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 4
    }
    
    private let loseCountLabel = UILabel().then {
        $0.text = "5"
        $0.font = .pretendard(.titleXlSb)
        $0.textColor = .Text.red
    }
    
    private let loseTitleLabel = UILabel().then {
        $0.text = "패배"
        $0.font = .pretendard(.captionXsM)
        $0.textColor = .Text.secondary
    }
    
    private let rateStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 4
    }
    
    private let ratePercentageLabel = UILabel().then {
        $0.text = "70.5%"
        $0.font = .pretendard(.titleXlSb)
        $0.textColor = .Text.primary
    }
    
    private let rateTitleLabel = UILabel().then {
        $0.text = "승률"
        $0.font = .pretendard(.captionXsM)
        $0.textColor = .Text.secondary
    }
    
    private let divider1 = UIView().then { $0.backgroundColor = .darkGray }
    private let divider2 = UIView().then { $0.backgroundColor = .darkGray }
    
    // MARK: - Setup
    
    override func setUI() {
        addSubview(containerView)
        containerView.addSubview(mainStackView)
        
        winStack.addArrangedSubviews(winCountLabel, winTitleLabel)
        loseStack.addArrangedSubviews(loseCountLabel, loseTitleLabel)
        rateStack.addArrangedSubviews(ratePercentageLabel, rateTitleLabel)
        
        mainStackView.addArrangedSubviews(winStack, loseStack, rateStack)
        containerView.addSubviews(divider1, divider2)
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(78)
        }
        
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        divider1.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(54)
            $0.centerY.equalToSuperview()
            $0.centerX.equalTo(containerView.snp.right).multipliedBy(1.0/3.0)
        }
        
        divider2.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(54)
            $0.centerY.equalToSuperview()
            $0.centerX.equalTo(containerView.snp.right).multipliedBy(2.0/3.0)
        }
    }
}

import UIKit

import SnapKit
import Then

final class ReviewCard: BaseUIView {
    
    // MARK: - Properties
    
    var seeAllAction: (() -> Void)?
    
    // MARK: - UI Components
    
    private let containerView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "받은 후기"
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.primary
    }
    
    private lazy var seeAllButton = UIButton().then {
        $0.setTitle("모두 보기", for: .normal)
        $0.titleLabel?.font = .pretendard(.textSmSb)
        $0.setTitleColor(.Text.tertiary, for: .normal)
        $0.addTarget(self, action: #selector(seeAllButtonTapped), for: .touchUpInside)
    }
    
    //
    
    override func setUI() {
        addSubview(containerView)
        
        containerView.addSubviews(titleLabel, seeAllButton)
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        
        seeAllButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        
    }
    
    // MARK: - Actions
    
    @objc private func seeAllButtonTapped() {
        seeAllAction?()
    }
}

import SwiftUI
@available(iOS 18.0, *)
#Preview {
    MyprofileViewController()
}
