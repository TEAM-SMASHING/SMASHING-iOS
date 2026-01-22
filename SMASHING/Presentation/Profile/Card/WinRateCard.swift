//
//  WinRateCard.swift
//  SMASHING
//
//  Created by 이승준 on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class WinRateCard: BaseUIView {
    
    // MARK: - UI Components
    
    private let usesContainerView: Bool

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
    
    private let divider1 = UIView().then { $0.backgroundColor = .Border.primary }
    private let divider2 = UIView().then { $0.backgroundColor = .Border.primary }
    
    // MARK: - Setup
    
    init(usesContainerView: Bool = true) {
        self.usesContainerView = usesContainerView
        super.init(frame: .zero)
    }

    override init(frame: CGRect) {
        self.usesContainerView = true
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setUI() {
        if usesContainerView {
            addSubview(containerView)
            containerView.addSubview(mainStackView)
        } else {
            addSubview(mainStackView)
        }
        
        winStack.addArrangedSubviews(winCountLabel, winTitleLabel)
        loseStack.addArrangedSubviews(loseCountLabel, loseTitleLabel)
        rateStack.addArrangedSubviews(ratePercentageLabel, rateTitleLabel)
        
        mainStackView.addArrangedSubviews(winStack, loseStack, rateStack)
        if usesContainerView {
            containerView.addSubviews(divider1, divider2)
        } else {
            addSubviews(divider1, divider2)
        }
    }
    
    override func setLayout() {
        if usesContainerView {
            containerView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.height.equalTo(78)
            }
        }
        
        let parentView = usesContainerView ? containerView : self
        
        mainStackView.snp.makeConstraints {
            $0.edges.equalTo(parentView)
        }
        
        divider1.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(54)
            $0.centerY.equalTo(parentView)
            $0.centerX.equalTo(parentView.snp.right).multipliedBy(1.0/3.0)
        }
        
        divider2.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(54)
            $0.centerY.equalTo(parentView)
            $0.centerX.equalTo(parentView.snp.right).multipliedBy(2.0/3.0)
        }
    }
    
    func configure(profile: MyProfileListResponse) {
        let total = profile.activeProfile.wins + profile.activeProfile.losses
        let rate = total == 0 ? 0.0 : Float(profile.activeProfile.wins) / Float(total)
        let roundedRate = (rate * 1000).rounded() / 10
        let displayRate = (roundedRate == floor(roundedRate))
                          ? String(Int(roundedRate))
                          : String(roundedRate)
        
        winCountLabel.text = profile.activeProfile.wins.description
        loseCountLabel.text = profile.activeProfile.losses.description
        ratePercentageLabel.text = displayRate.description + "%"
    }

    func configure(profile: OtherUserProfileResponse) {
        let total = profile.selectedProfile.wins + profile.selectedProfile.losses
        let rate = total == 0 ? 0.0 : Float(profile.selectedProfile.wins) / (Float(total))
        let roundedRate = (rate * 1000).rounded() / 10
        let displayRate = (roundedRate == floor(roundedRate))
                          ? String(Int(roundedRate))
                          : String(roundedRate)
        
        winCountLabel.text = profile.selectedProfile.wins.description
        loseCountLabel.text = profile.selectedProfile.losses.description
        ratePercentageLabel.text = displayRate.description + "%"
    }
}
