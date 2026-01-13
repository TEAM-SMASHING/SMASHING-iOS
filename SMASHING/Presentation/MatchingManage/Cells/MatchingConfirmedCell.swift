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
        $0.layer.cornerRadius = 12
    }

    private let profileImageView = UIImageView().then {
        $0.backgroundColor = .Background.canvasReverse
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 30
    }

    private let cameraIconImageView = UIImageView().then {
        $0.image = UIImage(systemName: "camera.fill")
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }

    private let nicknameLabel = UILabel().then {
        $0.font = .pretendard(.textSmSb)
        $0.textColor = .Text.primary
        $0.text = "닉네임"
    }

    private let tierBadgeLabel = UILabel().then {
        $0.font = .pretendard(.captionXsR)
        $0.textAlignment = .center
        $0.layer.cornerRadius = 4
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

    private let viewDetailsButton = UIButton().then {
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
        $0.layer.cornerRadius = 12
    }

    // MARK: - Properties

    var onViewDetailsTapped: (() -> Void)?

    // MARK: - Setup Methods

    override func setUI() {
        super.setUI()
        contentView.addSubview(containerView)
        containerView.addSubviews(
            profileImageView,
            cameraIconImageView,
            nicknameLabel,
            tierBadgeLabel,
            recordStackView,
            reviewStackView,
            viewDetailsButton,
            acceptButton
        )
    }

    override func setLayout() {
        super.setLayout()

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }

        acceptButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-12)
            $0.width.equalTo(60)
            $0.height.equalTo(28)
        }

        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(60)
        }

        cameraIconImageView.snp.makeConstraints {
            $0.trailing.equalTo(nicknameLabel.snp.leading).offset(-4)
            $0.centerY.equalTo(nicknameLabel)
            $0.size.equalTo(16)
        }

        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview().offset(10)
        }

        tierBadgeLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
            $0.width.greaterThanOrEqualTo(70)
        }

        recordStackView.snp.makeConstraints {
            $0.top.equalTo(tierBadgeLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        reviewStackView.snp.makeConstraints {
            $0.top.equalTo(recordStackView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        viewDetailsButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
            $0.height.equalTo(44)
        }
    }

    override func setAction() {
        super.setAction()
        viewDetailsButton.addTarget(self, action: #selector(viewDetailsButtonDidTap), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func viewDetailsButtonDidTap() {
        self.onViewDetailsTapped?()
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
        } else {
            self.tierBadgeLabel.backgroundColor = .Background.canvasReverse
            self.tierBadgeLabel.textColor = .Text.primary
        }
    }
}

