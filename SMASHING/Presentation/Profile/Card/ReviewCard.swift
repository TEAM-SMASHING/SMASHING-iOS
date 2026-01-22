//
//  ReviewCard.swift
//  SMASHING
//
//  Created by 이승준 on 1/15/26.
//

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
    
    private let bestSportsChip = SatisfictionChip(review: .best, num: 0)
    private let goodSportsChip = SatisfictionChip(review: .good, num: 0)
    private let badSportsChip = SatisfictionChip(review: .bad, num: 0)
    
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
        
        satisfactionStackView.addArrangedSubviews(bestSportsChip, goodSportsChip, badSportsChip)
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
            $0.top.equalTo(satisfactionStackView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(0)
        }
    }
    
    func configure(review: ReviewSummaryResponse) {
        bestSportsChip.setNum(review.ratingCounts.best)
        goodSportsChip.setNum(review.ratingCounts.good)
        badSportsChip.setNum(review.ratingCounts.bad)
    }

    func updateEmptyState(isEmpty: Bool) {
        noReviewLabel.isHidden = !isEmpty
        reviewCollectionView.isHidden = isEmpty
        satisfactionStackView.isHidden = isEmpty
        
        if isEmpty {
            noReviewLabel.snp.remakeConstraints {
                $0.center.equalToSuperview()
            }
        } else {
            reviewCollectionView.snp.remakeConstraints {
                $0.top.equalTo(satisfactionStackView.snp.bottom).offset(12)
                $0.horizontalEdges.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview().inset(16)
                $0.height.equalTo(0)
            }
        }
    }
    
    private let sizingCell = ReviewCollectionViewCell()

    func updateCollectionViewHeight(with data: [RecentReviewResult]) {
        let itemCount = data.count >= 3 ? 3 : data.count
        var totalHeight: CGFloat = 0
        let width = reviewCollectionView.frame.width
        
        for i in 0..<itemCount {
            sizingCell.configure(data[i])
            
            let targetSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
            let estimatedSize = sizingCell.contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
            totalHeight += estimatedSize.height
        }
        
        if let layout = reviewCollectionView.collectionViewLayout as? UICollectionViewFlowLayout, itemCount > 1 {
            totalHeight += layout.minimumLineSpacing * CGFloat(itemCount - 1)
        }
        
        reviewCollectionView.snp.updateConstraints {
            $0.height.equalTo(totalHeight)
        }
    }
    
    // MARK: - Actions
    
    @objc private func seeAllButtonTapped() {
        seeAllAction?()
    }
}
