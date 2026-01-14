//
//  SentRequestCell.swift
//  SMASHING
//
//  Created by JIN on 1/13/26.
//

import UIKit
import SnapKit
import Then

final class SentRequestCell: BaseUICollectionViewCell, ReuseIdentifiable {

    // MARK: - UI Components

    private let containerView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 8
    }

    private let closeButton = UIButton().then {
        $0.setImage(.icCloseSm, for: .normal)
        $0.tintColor = .Text.tertiary
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

    private let recordTitleLabel = UILabel().then {
        $0.text = "전적"
        $0.font = .pretendard(.captionXsM)
        $0.textColor = .Text.tertiary
    }

    private let recordValueLabel = UILabel().then {
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
        $0.font = .pretendard(.textSmM)
        $0.textColor = .Text.secondary
        $0.textAlignment = .right
    }

    private let recordStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
    }

    private let reviewStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
    }

    private let profileStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }

    // MARK: - Properties

    var onCloseTapped: (() -> Void)?

    // MARK: - Setup Methods

    override func setUI() {
        super.setUI()
        contentView.addSubview(containerView)
        containerView.addSubviews(
            closeButton,
            profileStackView,
            recordStackView,
            reviewStackView
        )
        nicknameStackView.addArrangedSubviews(nicknameLabel, genderIconImageView)
        profileStackView.addArrangedSubviews(profileImageView, nicknameStackView, tierBadgeLabel)
        recordStackView.addArrangedSubviews(recordTitleLabel, recordValueLabel)
        reviewStackView.addArrangedSubviews(reviewTitleLabel, reviewValueLabel)
    }

    override func setLayout() {
        super.setLayout()

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        closeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(15.5)
            $0.size.equalTo(20)
        }

        profileStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
        }

        profileImageView.snp.makeConstraints {
            $0.size.equalTo(52)
        }

        genderIconImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }

        tierBadgeLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(67)
        }

        recordStackView.snp.makeConstraints {
            $0.top.equalTo(profileStackView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(19.5)
        }

        reviewStackView.snp.makeConstraints {
            $0.top.equalTo(recordStackView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(19.5)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }

    override func setAction() {
        super.setAction()
        closeButton.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func closeButtonDidTap() {
        self.onCloseTapped?()
    }

    // MARK: - Configuration

    func configure(
        nickname: String,
        gender: String,
        tier: String,
        wins: Int,
        losses: Int,
        reviews: Int
    ) {
        self.nicknameLabel.text = nickname
        self.genderIconImageView.image = gender == "MALE" ? .icManSm : .icWomanSm
        self.recordValueLabel.text = "\(wins)승 \(losses)패"
        self.reviewValueLabel.text = "\(reviews)"
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
