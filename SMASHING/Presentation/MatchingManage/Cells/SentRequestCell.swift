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

    private lazy var closeButton = UIButton().then {
        $0.setImage(.icCloseSm, for: .normal)
        $0.tintColor = .Text.tertiary
        $0.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
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

    // MARK: - Actions

    @objc private func closeButtonDidTap() {
        self.onCloseTapped?()
    }

    // MARK: - Configuration

    func configure(with receiver: SentRequestReceiverDTO) {
        self.nicknameLabel.text = receiver.nickname
        self.genderIconImageView.image = receiver.gender == "MALE" ? .icManSm : .icWomanSm
        self.recordValueLabel.text = "\(receiver.wins)승 \(receiver.losses)패"
        self.reviewValueLabel.text = "\(receiver.reviewCount)"
        self.configureTierBadge(tierId: receiver.tierID)
    }

    private func configureTierBadge(tierId: Int) {
        guard let tier = Tier.from(tierId: tierId) else {
            self.tierBadgeLabel.text = "Unranked"
            self.tierBadgeLabel.backgroundColor = .Background.canvasReverse
            self.tierBadgeLabel.textColor = .Text.primary
            return
        }
        
        self.tierBadgeLabel.text = tier.displayName
        self.tierBadgeLabel.backgroundColor = tier.backgroundColor
        self.tierBadgeLabel.textColor = tier.textColor
    }
}
