//
//  UserProfileView.swift
//  SMASHING
//
//  Created by 이승준 on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class UserProfileView: BaseUIView {
    
    // MARK: - Enum
    
    enum Mode {
        case plain, canAccept, cannotChallenge
    }
    
    // MARK: - Properties
    
    var skipAction: (() -> Void)?
    var acceptAction: (() -> Void)?
    var backAction: (() -> Void)?
    var challengeAction: (() -> Void)? {
        didSet { profileCard.challengeAction = challengeAction }
    }
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var navigationBar = CustomNavigationBar(
        title: "프로필", leftAction: { [weak self] in
        self?.backAction?()
    })
    
    private let profileCard = ProfileCard().then {
        $0.addChallengeButton()
    }
    
    let tierCard = TierCard().then {
        $0.showsAddButton = false
    }
    
    private let winRateCard = WinRateCard()
    
    let reviewCard = ReviewCard()
    
    private lazy var skipButton = UIButton().then {
        $0.setTitle("건너뛰기", for: .normal)
        $0.setTitleColor(.Button.textSecondaryActive, for: .normal)
        $0.backgroundColor = .Button.backgroundPrimaryDisabled
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(skipButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var acceptButton = CTAButton(label: "수락") {
        self.acceptAction?()
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        addSubview(navigationBar)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(profileCard, winRateCard, reviewCard, tierCard)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        profileCard.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(222)
        }
        
        tierCard.snp.makeConstraints {
            $0.top.equalTo(profileCard.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(264)
        }
        
        winRateCard.snp.makeConstraints {
            $0.top.equalTo(tierCard.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        reviewCard.snp.makeConstraints {
            $0.top.equalTo(winRateCard.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configure(mode: UserProfileView.Mode) {
        switch mode {
        case .plain:
            profileCard.changeButtonState(isEnabled: true)
            showBottomButtons(isShown: false)
        case .canAccept:
            profileCard.changeButtonState(isEnabled: false)
            showBottomButtons(isShown: true)
        case .cannotChallenge:
            profileCard.changeButtonState(isEnabled: false)
            showBottomButtons(isShown: false)
        }
    }

    func configure(with profile: OtherUserProfileResponse, mode: UserProfileView.Mode) {
        profileCard.configure(profile: profile)
        tierCard.configure(profile: profile)
        winRateCard.configure(profile: profile)
        configure(mode: mode)
        if mode == .plain {
            profileCard.changeButtonState(isEnabled: profile.isChallengeable)
        }
    }
    
    private func showBottomButtons(isShown: Bool) {
        if isShown {
            skipButton.isHidden = !isShown
            acceptButton.isHidden = !isShown
            
            contentView.addSubviews(skipButton, acceptButton)
            
            skipButton.snp.makeConstraints {
                $0.bottom.equalTo(safeAreaLayoutGuide).offset(18)
                $0.leading.equalToSuperview().inset(16)
                $0.width.equalTo(151)
                $0.height.equalTo(46)
            }
            
            acceptButton.snp.makeConstraints {
                $0.bottom.equalTo(safeAreaLayoutGuide).offset(18)
                $0.trailing.equalToSuperview().inset(16)
                $0.leading.equalTo(skipButton.snp.trailing).inset(-16)
            }
            
            reviewCard.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(50)
            }
        } else {
            skipButton.isHidden = !isShown
            acceptButton.isHidden = !isShown
            
            reviewCard.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(20)
            }
        }
    }
    
    @objc private func skipButtonDidTap() {
        skipAction?()
        configure(mode: .plain)
    }
}
