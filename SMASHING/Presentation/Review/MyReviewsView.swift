//
//  MyReviewsView.swift
//  SMASHING
//
//  Created by 이승준 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class MyReviewsView: BaseUIView {
    
    // MARK: - Properties
    
    var backAction: (() -> Void)? {
        didSet {
            navigationBar.setLeftButton(action: backAction ?? {})
        }
    }
    
    // MARK: - UI Components
    
    private let navigationBar = CustomNavigationBar(title: "받은 후기")
    
    private let satisfactionLabel = UILabel().then {
        $0.text = "만족도"
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.primary
    }
    
    private let satisfactionStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .leading
    }
    
    private let bestReviewChip = SatisfictionChip(review: .best, num: 0)
    private let goodReviewChip = SatisfictionChip(review: .good, num: 0)
    private let badReviewChip = SatisfictionChip(review: .bad, num: 0)
    
    private let quickReviewLabel = UILabel().then {
        $0.text = "빠른 후기"
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.primary
    }
    
    private let firstReviewStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .leading
    }
    
    private let secondReviewStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .leading
    }
    
    private let goodMannerCountChip = ReviewCountChip().then {
        $0.configure(with: .goodManner, count: 0)
    }
    
    private let onTimeCountChip = ReviewCountChip().then {
        $0.configure(with: .onTime, count: 0)
    }
    
    private let fairPlayCountChip = ReviewCountChip().then {
        $0.configure(with: .fairPlay, count: 0)
    }
    
    private let fastResponseCountChip = ReviewCountChip().then {
        $0.configure(with: .fastResponse, count: 0)
    }
    
    private let allReviewLabel = UILabel().then {
        $0.text = "후기"
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.primary
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(ReviewCollectionViewCell.self, forCellWithReuseIdentifier: ReviewCollectionViewCell.reuseIdentifier)
        return cv
    }()
    
    // MARK: - Setup Methods
    
    override func setUI() {
        addSubviews(navigationBar, satisfactionLabel, satisfactionStackView,
                            quickReviewLabel, firstReviewStackView, secondReviewStackView,
                            allReviewLabel, collectionView)
                
        firstReviewStackView.addArrangedSubviews(goodMannerCountChip, onTimeCountChip)
        secondReviewStackView.addArrangedSubviews(fairPlayCountChip, fastResponseCountChip)
        
        satisfactionStackView.addArrangedSubviews(bestReviewChip, goodReviewChip, badReviewChip)
        
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(safeAreaLayoutGuide)
        }
        
        satisfactionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(navigationBar.snp.bottom)
        }
        
        satisfactionStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(satisfactionLabel.snp.bottom).offset(8)
            $0.height.equalTo(40)
        }
        
        quickReviewLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(satisfactionStackView.snp.bottom).offset(32)
        }
        
        firstReviewStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(quickReviewLabel.snp.bottom).offset(8)
            $0.height.equalTo(40)
        }
        
        secondReviewStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(firstReviewStackView.snp.bottom).offset(8)
            $0.height.equalTo(40)
        }
        
        allReviewLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(secondReviewStackView.snp.bottom).offset(32)
        }
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(allReviewLabel.snp.bottom).offset(8)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func configure(summary: ReviewSummaryResponse) {
        bestReviewChip.setNum(summary.ratingCounts.best)
        goodReviewChip.setNum(summary.ratingCounts.good)
        badReviewChip.setNum(summary.ratingCounts.bad)
        
        goodMannerCountChip.setNum(num: summary.tagCounts.goodManner)
        onTimeCountChip.setNum(num: summary.tagCounts.onTime)
        fairPlayCountChip.setNum(num: summary.tagCounts.fairPlay)
        fastResponseCountChip.setNum(num: summary.tagCounts.fastResponse)
    }
    
    @objc private func backButtonTapped() {
        backAction?()
    }
}
