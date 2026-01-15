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
            $0.top.equalTo(satisfactionStackView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
        
    // MARK: - Actions
    
    @objc private func seeAllButtonTapped() {
        seeAllAction?()
    }
}
