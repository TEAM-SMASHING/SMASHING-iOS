//
//  ReceiveRequestCell.swift
//  SMASHING
//
//  Created by JIN on 1/13/26.
//

import UIKit
import SnapKit
import Then

final class ReceiveRequestCell: BaseUICollectionViewCell, ReuseIdentifiable {

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
        $0.text = "닉네임"
    }

    private let genderIconImageView = UIImageView().then {
        $0.image = .icWomanSm
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }

    private lazy var nicknameStackView = UIStackView(arrangedSubviews: [nicknameLabel, genderIconImageView]).then {
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

    private let recordTitleLabel = UILabel().then {
        $0.text = "전적"
        $0.font = .pretendard(.captionXsM)
        $0.textColor = .Text.tertiary
    }

    private let recordValueLabel = UILabel().then {
        $0.text = "254승 38패"
        $0.font = .pretendard(.textSmM)
        $0.textColor = .Text.secondary
        $0.textAlignment = .right
    }

    private let reviewTitleLabel = UILabel().then {
        $0.text = "후기"
        $0.font = .pretendard(.captionXsM)
        $0.textColor = .Text.tertiary
    }

    private let reviewValueLabel = UILabel().then {
        $0.text = "32"
        $0.font = .pretendard(.textSmM)
        $0.textColor = .Text.secondary
        $0.textAlignment = .right
    }

    private lazy var recordStackView = UIStackView(arrangedSubviews: [recordTitleLabel, recordValueLabel]).then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
    }

    private lazy var reviewStackView = UIStackView(arrangedSubviews: [reviewTitleLabel, reviewValueLabel]).then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
    }

    private let skipButton = UIButton().then {
        $0.setTitle("건너뛰기", for: .normal)
        $0.setTitleColor(.Text.tertiary, for: .normal)
        $0.titleLabel?.font = .pretendard(.captionXsR)
        $0.backgroundColor = .clear
    }

    private let acceptButton = UIButton().then {
        $0.setTitle("수락", for: .normal)
        $0.setTitleColor(.Text.primary, for: .normal)
        $0.titleLabel?.font = .pretendard(.textSmM)
        $0.backgroundColor = .Button.backgroundSecondaryActive
        $0.layer.cornerRadius = 4
    }

    private lazy var buttonStackView = UIStackView(arrangedSubviews: [skipButton, acceptButton]).then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .center
        $0.spacing = 8
    }

    // MARK: - Properties

    var onSkipTapped: (() -> Void)?
    var onAcceptTapped: (() -> Void)?

    // MARK: - Setup Methods

    override func setUI() {
        super.setUI()
        contentView.addSubview(containerView)
        containerView.addSubviews(
            profileImageView,
            nicknameStackView,
            tierBadgeLabel,
            recordStackView,
            reviewStackView,
            buttonStackView
        )
    }

    override func setLayout() {
        super.setLayout()

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(52)
        }

        nicknameStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }

        genderIconImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }

        tierBadgeLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameStackView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
            $0.width.equalTo(67)
        }

        recordStackView.snp.makeConstraints {
            $0.top.equalTo(tierBadgeLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(19.5)
        }

        reviewStackView.snp.makeConstraints {
            $0.top.equalTo(recordStackView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(19.5)
        }

        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(reviewStackView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24.5)
            $0.width.equalTo(117)
            $0.height.equalTo(29)
        }
    }

    override func setAction() {
        super.setAction()
        skipButton.addTarget(self, action: #selector(skipButtonDidTap), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptButtonDidTap), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func skipButtonDidTap() {
        self.onSkipTapped?()
    }

    @objc private func acceptButtonDidTap() {
        self.onAcceptTapped?()
    }

    // MARK: - Configuration

    func configure(nickname: String, tier: String, wins: Int, losses: Int, reviews: Int) {
        self.nicknameLabel.text = nickname
        self.recordValueLabel.text = "\(wins)승 \(losses)패"
        self.reviewValueLabel.text = "\(reviews)"
        self.configureTierBadge(tier: tier)
    }

    private func configureTierBadge(tier: String) {
        self.tierBadgeLabel.text = tier

        if tier.contains("Gold") {
            self.tierBadgeLabel.backgroundColor = .Tier.goldBackground
            self.tierBadgeLabel.textColor = .Tier.goldText
        } else if tier.contains("Bronze") {
            self.tierBadgeLabel.backgroundColor = .Tier.bronzeBackground
            self.tierBadgeLabel.textColor = .Tier.bronzeText
        } else if tier.contains("Challenger") {
            self.tierBadgeLabel.backgroundColor = .Tier.challengerBackground
            self.tierBadgeLabel.textColor = .Tier.challengerText
        } else if tier.contains("Silver") {
            self.tierBadgeLabel.backgroundColor = .Tier.silverBackground
            self.tierBadgeLabel.textColor = .Tier.silverText
        } else if tier.contains("Diamond") {
            self.tierBadgeLabel.backgroundColor = .Tier.diamondBackground
            self.tierBadgeLabel.textColor = .Tier.diamondText
        } else {
            self.tierBadgeLabel.backgroundColor = .Background.canvasReverse
            self.tierBadgeLabel.textColor = .Text.primary
        }
    }
}
