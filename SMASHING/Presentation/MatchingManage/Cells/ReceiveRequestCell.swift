//
//  ReceiveRequestCell.swift
//  SMASHING
//
//  Created by JIN on 1/13/26.
//

import UIKit
import SnapKit
import Then
import SwiftUI

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

    private lazy var skipButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.addTarget(self, action: #selector(skipButtonDidTap), for: .touchUpInside)
    }

    private let skipIconImageView = UIImageView().then {
        $0.image = UIImage(named: "ic_close-sm")
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = false
    }

    private lazy var acceptButton = UIButton().then {
        $0.backgroundColor = .Button.backgroundSecondaryActive
        $0.layer.cornerRadius = 4
        $0.addTarget(self, action: #selector(acceptButtonDidTap), for: .touchUpInside)
    }

    private let acceptIconImageView = UIImageView().then {
        $0.image = UIImage(named: "ic_check")
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = false
    }
    
    private let buttonStackView = UIStackView().then {
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
        contentView.addSubview(containerView)
        containerView.addSubviews(
            profileStackView,
            recordStackView,
            reviewStackView,
            buttonStackView
        )
        nicknameStackView.addArrangedSubviews(nicknameLabel, genderIconImageView)
        profileStackView.addArrangedSubviews(profileImageView, nicknameStackView, tierBadgeLabel)
        recordStackView.addArrangedSubviews(recordTitleLabel, recordValueLabel)
        reviewStackView.addArrangedSubviews(reviewTitleLabel, reviewValueLabel)
        buttonStackView.addArrangedSubviews(skipButton, acceptButton)
        skipButton.addSubview(skipIconImageView)
        acceptButton.addSubview(acceptIconImageView)
    }

    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        profileStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
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
        }

        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(reviewStackView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(14)
            $0.height.equalTo(29)
        }

        skipButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }

        skipIconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(24)
        }

        acceptButton.snp.makeConstraints {
            $0.height.equalTo(29)
            $0.width.equalTo(55)
        }

        acceptIconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(24)
        }
    }

    @objc private func skipButtonDidTap() {
        self.onSkipTapped?()
    }

    @objc private func acceptButtonDidTap() {
        self.onAcceptTapped?()
    }

    // MARK: - Configuration

    func configure(with requester: RequesterSummaryDTO) {
        self.nicknameLabel.text = requester.nickname
        self.genderIconImageView.image = requester.gender.imageSm
        self.profileImageView.image = UIImage.defaultProfileImage(name: requester.nickname)
        self.recordValueLabel.text = "\(requester.wins)승 \(requester.losses)패"
        self.reviewValueLabel.text = "\(requester.reviewCount)"
        self.configureTierBadge(tierCode: requester.tierCode)
    }

    private func configureTierBadge(tierCode: String) {
        guard let tier = Tier.from(tierCode: tierCode) else {
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

// MARK: - Preview

#if DEBUG
private struct ReceiveRequestCellPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBackground

        let cell = ReceiveRequestCell()
        let mockDTO = RequesterSummaryDTO(
            userID: "preview-id",
            nickname: "스매셔",
            gender: .male,
            reviewCount: 12,
            tierCode: "GOLD",
            wins: 8,
            losses: 3
        )
        cell.configure(with: mockDTO)

        vc.view.addSubview(cell)
        cell.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(220)
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

#Preview {
    ReceiveRequestCellPreview()
}
#endif
