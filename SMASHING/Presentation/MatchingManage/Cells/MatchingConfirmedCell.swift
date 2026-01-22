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
    
    private lazy var writeResult = UIButton().then {
        $0.titleLabel?.font = .pretendard(.textSmM)
        $0.layer.cornerRadius = 4
        $0.addTarget(self, action: #selector(writeResultButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var closeButton = UIButton().then {
        $0.setImage(.icCloseSm, for: .normal)
        $0.tintColor = .Text.tertiary
        $0.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Properties
    
    var onCloseTapped: (() -> Void)?
    var onSkipTapped: (() -> Void)?
    var onAcceptTapped: (() -> Void)?
    
    // MARK: - Setup Methods
    
    override func setUI() {
        contentView.addSubview(containerView)
        containerView.addSubviews(
            profileStackView,
            kakaoLinkStackView,
            writeResult,
            closeButton
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
    
    // MARK: - Actions
    
    @objc private func closeButtonDidTap() {
        self.onCloseTapped?()
    }
    
    @objc private func writeResultButtonDidTap() {
        self.onAcceptTapped?()
    }
    
    
    // MARK: - Configuration
    
    func configure(with game: MatchingConfirmedGameDTO, myUserId: String) {
        let opponent = game.opponent
        self.nicknameLabel.text = opponent.nickname
        self.genderIconImageView.image = opponent.gender.imageSm
        self.configureTierBadge(tierCode: opponent.tierCode)
        let isMySubmission = game.latestSubmitterId == myUserId
        self.updateWriteResultButton(resultState: game.resultStatus, isMySubmission: isMySubmission, isSubmitLocked: game.isSubmitLocked)
    }
    
    private func updateWriteResultButton(resultState: GameResultStatus, isMySubmission: Bool, isSubmitLocked: Bool) {
        let canConfirm = resultState.canConfirm(isMySubmission: isMySubmission)
        let canSubmit = resultState.canSubmit(isMySubmission: isMySubmission) && !isSubmitLocked
        let title = resultState.buttonTitle(isMySubmission: isMySubmission)
        
        self.writeResult.setTitle(title, for: .normal)
        self.writeResult.isEnabled = canSubmit || canConfirm
        
        switch resultState {
        case .resultConfirmed:
            self.writeResult.backgroundColor = .Button.backgroundConfirmed
            self.writeResult.setTitleColor(.Text.emphasis, for: .normal)
        case .pendingResult:
            self.writeResult.setTitleColor(.Text.emphasis, for: .normal)
            self.writeResult.backgroundColor = .Button.backgroundPrimaryActive
        case .resultRejected:
            if canSubmit {
                print("이거야?")
                self.writeResult.backgroundColor = .Button.backgroundRejected
                self.writeResult.setTitleColor(.Button.textRejected, for: .normal)
            } else {
                print("이건가")
                self.writeResult.backgroundColor = .Button.backgroundPrimaryDisabled
                self.writeResult.setTitleColor(.Button.textPrimaryDisabled, for: .normal)
            }
        case .canceled:
            self.writeResult.backgroundColor = .Button.backgroundPrimaryDisabled
            self.writeResult.setTitleColor(.Button.textPrimaryDisabled, for: .normal)
        case .waitingConfirmation:
            if canConfirm {
                self.writeResult.backgroundColor = .Button.backgroundConfirmed
                self.writeResult.setTitleColor(.Button.backgroundSecondaryActive, for: .normal)
            } else {
                self.writeResult.backgroundColor = .Button.backgroundPrimaryDisabled
                self.writeResult.setTitleColor(.Button.textPrimaryDisabled, for: .normal)
            }
        }
    }
    
    private func configureTierBadge(tierCode: String?) {
        guard let tierCode = tierCode, let tier = Tier.from(tierCode: tierCode) else {
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

