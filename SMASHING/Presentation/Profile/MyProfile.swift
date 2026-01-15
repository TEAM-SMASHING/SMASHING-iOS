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
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let navigationBar = CustomNavigationBar(title: "프로필").then {
        $0.setLeftButtonHidden(true)
    }
    
    private let profileCard = ProfileCard()
    
    let tierCard = TierCard().then {
        $0.addTierDetailButton()
    }
    
    private let winRateCard = WinRateCard()
    
    let reviewCard = ReviewCard()
    
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
            $0.height.equalTo(160)
        }
        
        tierCard.snp.makeConstraints {
            $0.top.equalTo(profileCard.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(330)
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
}

final class ProfileCard: BaseUIView {
    
    // MARK: - Properties
    
    private var challengeAction: (() -> Void)?
    
    // MARK: - UI Componetns
    
    private let containerView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
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
        addSubview(containerView)
        containerView.addSubviews(profileImage, titleLabel, genderIcon, tierIcon,
                    recordLabel, reviewLabel, winLoseRecordLabel, reviewCountsLabel)
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
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
        challengeAction?()
    }
}

import UIKit

import SnapKit
import Then

final class TierCard: BaseUIView {
    
    // MARK: - Properties
    
    private var tierDetailAction: (() -> Void)?
    
    private var addAction: (() -> Void)?
    
    private var sportsSelectedAction: ((Sports) -> Void)?
    
    // MARK: - UI Components
    
    private let containerView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let sportsStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 7
    }
    
    private let tierImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .Background.overlay
    }
    
    private let tierMark = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let progressBar = UIProgressView().then {
        $0.tintColor = .State.progressFill
        $0.backgroundColor = .State.progressTrack
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.progress = 0.4
    }
    
    private let lastLPLabel = UILabel().then {
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.primary
        $0.text = "100"
    }
    
    private let lpLeft = UILabel().then {
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.tertiary
        $0.text = "LP 남았어요!"
    }
    
    private let lpLabel = UILabel().then {
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.tertiary
        $0.text = "LP"
    }
    
    private let totalLPLabel = UILabel().then {
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.primary
        $0.text = "500"
    }
    
    private lazy var tierDetailButton = BlueCTAButton(label: "티어 설명").then {
        $0.addTarget(self, action: #selector(detailTapped), for: .touchUpInside)
    }
    
    override func setUI() {
        addSubview(containerView)
        
        containerView.addSubviews(sportsStackView, tierImage, tierMark, progressBar,
                                  lastLPLabel, lpLeft, lpLabel, totalLPLabel)
        
        sportsStackView.addArrangedSubviews(
            SportsButtonChip(sports: .badminton, selected: true),
            SportsButtonChip(sports: .tableTennis),
            SportsButtonChip(sports: nil)
        )
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        sportsStackView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(16)
        }
        
        tierImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(sportsStackView.snp.bottom).offset(20)
            $0.size.equalTo(100)
        }
        
        progressBar.snp.makeConstraints {
            $0.top.equalTo(tierImage.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(8)
        }
        
        lastLPLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalTo(progressBar.snp.bottom).offset(8)
        }
        
        lpLeft.snp.makeConstraints {
            $0.leading.equalTo(lastLPLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(lastLPLabel)
        }
        
        totalLPLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(lastLPLabel)
        }
        
        lpLabel.snp.makeConstraints {
            $0.trailing.equalTo(totalLPLabel.snp.leading).inset(-4)
            $0.centerY.equalTo(lastLPLabel)
        }
    }
    
    func addTierDetailButton() {
        containerView.addSubview(tierDetailButton)
        tierDetailButton.snp.makeConstraints {
            $0.top.equalTo(lpLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Actions
    
    @objc private func detailTapped() {
        tierDetailAction?()
    }
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
    
    private let satisfactionStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .leading
    }
    
    private let noReviewLabel = UILabel().then {
        $0.text = "아직 받은 후기가 없어요"
        $0.font = .pretendard(.textSmR)
        $0.textColor = .Text.primary
    }
    
    lazy var reviewCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.register(ReviewCollectionViewCell.self, forCellWithReuseIdentifier: ReviewCollectionViewCell.reuseIdentifier)
        return cv
    }()
    
    // MARK: - Setup Methods
    
    override func setUI() {
        addSubview(containerView)
        
        containerView.addSubviews(titleLabel, seeAllButton, satisfactionStackView, noReviewLabel, reviewCollectionView)
        
        satisfactionStackView.addArrangedSubviews(
            SatisfictionChip(review: .best, num: Int.random(in: 0...150)),
            SatisfictionChip(review: .good,num: Int.random(in: 0...150)),
            SatisfictionChip(review: .bad, num: Int.random(in: 0...150)))
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
        
        satisfactionStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(40)
        }
        
        noReviewLabel.snp.makeConstraints {
            $0.top.equalTo(satisfactionStackView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
        }
        
        reviewCollectionView.snp.makeConstraints {
            $0.top.equalTo(satisfactionStackView.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
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
