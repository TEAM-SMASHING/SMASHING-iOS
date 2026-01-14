//
//  MatchingConfirmedCell.swift
//  SMASHING
//
//  Created by JIN on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class MatchingConfirmedCell: BaseUICollectionViewCell, ReuseIdentifiable {

    // MARK: - UI Components

    private let containerView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 8
    }

    private let profileImageView = UIImageView().then {
        $0.backgroundColor = .Background.canvasReverse
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 26
    }

    private let nicknameLabel = UILabel().then {
        $0.font = .pretendard(.textSmSb)
        $0.textColor = .Text.primary
    }

    private let genderIconImageView = UIImageView().then {
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }

    private let nicknameStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 2
        $0.alignment = .center
    }

    private let tierBadgeLabel = UILabel().then {
        $0.font = .pretendard(.captionXsR)
        $0.textAlignment = .center
        $0.layer.cornerRadius = 2
        $0.clipsToBounds = true
    }

    private let profileStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }

    private lazy var linkIcon = UIImageView().then {
        $0.image = .icLink
        $0.contentMode = .scaleAspectFit
    }

    private lazy var kakaoTalkLinkButton = UIButton().then {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.pretendard(.captionXsR),
            .foregroundColor: UIColor(resource: .Text.secondary),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedString = NSAttributedString(
            string: "카카오톡 링크",
            attributes: attributes
        )
        $0.setAttributedTitle(attributedString, for: .normal)
    }

    private let kakaoLinkStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }
    
    private let writeResult = UIButton().then {
        $0.setTitle("결과 작성하기", for: .normal)
        $0.setTitleColor(.Text.blue, for: .normal)
        $0.backgroundColor = .Button.backgroundPrimaryActive
        $0.titleLabel?.font = .pretendard(.textSmM)
        $0.layer.cornerRadius = 4
    }

    // MARK: - Properties

    var onSkipTapped: (() -> Void)?
    var onAcceptTapped: (() -> Void)?

    // MARK: - Setup Methods

    override func setUI() {
        super.setUI()
        contentView.addSubview(containerView)
        containerView.addSubviews(
            profileStackView,
            kakaoLinkStackView,
            writeResult
        )
        nicknameStackView.addArrangedSubviews(
            nicknameLabel,
            genderIconImageView
        )
        profileStackView.addArrangedSubviews(
            profileImageView,
            nicknameStackView,
            tierBadgeLabel
        )
        kakaoLinkStackView.addArrangedSubviews(
            kakaoTalkLinkButton,
            linkIcon
        )
        
    }

    override func setLayout() {
        super.setLayout()

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        profileStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
        }
        
        genderIconImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }

        tierBadgeLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(67)
        }

        profileImageView.snp.makeConstraints {
            $0.size.equalTo(52)
        }
        
        kakaoTalkLinkButton.snp.makeConstraints {
            $0.width.equalTo(66)
            $0.height.equalTo(18)
        }
        
        linkIcon.snp.makeConstraints {
            $0.size.equalTo(24)
        }

        kakaoLinkStackView.snp.makeConstraints {
            $0.top.equalTo(tierBadgeLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        writeResult.snp.makeConstraints {
            $0.top.equalTo(kakaoLinkStackView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(29)
        }

    }

    override func setAction() {
        super.setAction()
    }

    // MARK: - Actions

    @objc private func skipButtonDidTap() {
        self.onSkipTapped?()
    }

    @objc private func acceptButtonDidTap() {
        self.onAcceptTapped?()
    }

    // MARK: - Configuration

    func configure(
        nickname: String,
        gender: String,
        tier: String,
        wins: Int,
        losses: Int,
        reviews: Int) {
        self.nicknameLabel.text = nickname
        self.genderIconImageView.image = gender == "MALE" ? .icManSm : .icWomanSm
        self.configureTierBadge(tier: tier)
    }

    private func configureTierBadge(tier: String) {
        self.tierBadgeLabel.text = tier

        if tier.contains("Iron") {
            self.tierBadgeLabel.backgroundColor = .Tier.ironBackground
            self.tierBadgeLabel.textColor = .Tier.ironText
        } else if tier.contains("Bronze") {
            self.tierBadgeLabel.backgroundColor = .Tier.bronzeBackground
            self.tierBadgeLabel.textColor = .Tier.bronzeText
        } else if tier.contains("Silver") {
            self.tierBadgeLabel.backgroundColor = .Tier.silverBackground
            self.tierBadgeLabel.textColor = .Tier.silverText
        } else if tier.contains("Gold") {
            self.tierBadgeLabel.backgroundColor = .Tier.goldBackground
            self.tierBadgeLabel.textColor = .Tier.goldText
        } else if tier.contains("Platinum") {
            self.tierBadgeLabel.backgroundColor = .Tier.platinumBackground
            self.tierBadgeLabel.textColor = .Tier.platinumText
        } else if tier.contains("Diamond") {
            self.tierBadgeLabel.backgroundColor = .Tier.diamondBackground
            self.tierBadgeLabel.textColor = .Tier.diamondText
        } else if tier.contains("Challenger") {
            self.tierBadgeLabel.backgroundColor = .Tier.challengerBackground
            self.tierBadgeLabel.textColor = .Tier.challengerText
        } else {
            self.tierBadgeLabel.backgroundColor = .Background.canvasReverse
            self.tierBadgeLabel.textColor = .Text.primary
        }
    }
}

