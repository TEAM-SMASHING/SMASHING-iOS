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
    
    private var backAction: (() -> Void)?
    
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
    
    private let quickReviewLabel = UILabel().then {
        $0.text = "빠른 후기"
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.primary
    }
    
    private let quickReviewStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .leading
        $0.backgroundColor = .gray
    }
    
    private let allReviewLabel = UILabel().then {
        $0.text = "후기"
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.primary
    }
    
    let reviewCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .gray
        
        return collectionView
    }()
    
    // MARK: - Setup Methods
    
    override func setUI() {
        addSubviews(navigationBar, satisfactionLabel, satisfactionStackView,
                    quickReviewLabel, quickReviewStackView,
                    allReviewLabel, reviewCollectionView)
        
        [ReviewScore.best, .good, .bad].forEach { review in
            let chip = SatisfictionChip(review: review, num: Int.random(in: 0...150))
            satisfactionStackView.addArrangedSubview(chip)
        }
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
        
        quickReviewStackView.snp.makeConstraints {
            $0.top.equalTo(quickReviewLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(88)
        }
        
        allReviewLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(quickReviewStackView.snp.bottom).offset(32)
        }
        
        reviewCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(allReviewLabel.snp.bottom).offset(8)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
