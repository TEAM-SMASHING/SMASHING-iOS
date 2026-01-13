//
//  MatchResultCreateSecondView.swift
//  SMASHING
//
//  Created by 홍준범 on 1/13/26.
//

import UIKit

import SnapKit
import Then

enum SatisfactionLevel: Int, Codable {
    case bad, good, great
}

final class ReviewCreateView: BaseUIView {
    
    private var selectedSatisfaction: SatisfactionLevel?
    
    private let navigationBar = CustomNavigationBar(title: "매칭 결과 작성")
    
    private let titleLabel = UILabel().then {
        $0.text = "밤이달이님과의 경기는 어떠셨나요?"
        $0.setPretendard(.titleXlSb)
        $0.textColor = .Text.primary
    }
    
    private let satisfactionSelectionLabel = UILabel().then {
        $0.text = "만족도 선택"
        $0.setPretendard(.textMdM)
        $0.textColor = .Text.primary
    }
    
    private let satisfactionRequiredStar = UILabel().then {
        $0.text = "*"
        $0.setPretendard(.textMdM)
        $0.textColor = .Text.red
    }
    
    private let satisfactionContainer = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 12
    }
    
    private let leftLine = UIView().then {
        $0.backgroundColor = .Border.secondary
    }
    
    private let rightLine = UIView().then {
        $0.backgroundColor = .Border.secondary
    }
    
    private let badButton = SatisfactionButton(title: "별로예요")
    private let goodButton = SatisfactionButton(title: "좋아요")
    private let greatButton = SatisfactionButton(title: "최고예요")

    private let rapidReviewSelectionLabel = UILabel().then {
        $0.text = "빠른 후기를 선택해주세요"
        $0.setPretendard(.textMdM)
        $0.textColor = .Text.primary
    }
    
    let rapidReviewChipContainer = RapidReviewChipContainer(reviews: RapidReview.allCases)
    
    private let reviewDescription = UILabel().then {
        $0.text = "따뜻한 경기 후기를 보내주세요!"
        $0.setPretendard(.textMdM)
        $0.textColor = .Text.primary
    }
    
    private let reviewTextView = ReviewTextView()
    
    private let submitButton = CTAButton(label: "완료")
    
    override func setUI() {
        satisfactionContainer.addSubviews(leftLine, rightLine, badButton, goodButton, greatButton)
        
        addSubviews(navigationBar,
                    titleLabel,
                    satisfactionSelectionLabel,
                    satisfactionRequiredStar,
                    satisfactionContainer,
                    rapidReviewSelectionLabel,
                    rapidReviewChipContainer,
                    reviewDescription,
                    reviewTextView,
                    submitButton)
        
        badButton.circleButton.addTarget(self, action: #selector(badButtonDidTap), for: .touchUpInside)
        goodButton.circleButton.addTarget(self, action: #selector(goodButtonDidTap), for: .touchUpInside)
        greatButton.circleButton.addTarget(self, action: #selector(greatButtonDidTap), for: .touchUpInside)
    }
    
    @objc
    private func badButtonDidTap() {
        updateSatisfaction(.bad)
    }
    
    @objc
    private func goodButtonDidTap() {
        updateSatisfaction(.good)
    }
    
    @objc
    private func greatButtonDidTap() {
        updateSatisfaction(.great)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.equalToSuperview().inset(16)
        }
        
        satisfactionSelectionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.leading.equalToSuperview().inset(16)
        }
        
        satisfactionRequiredStar.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.leading.equalTo(satisfactionSelectionLabel.snp.trailing)
        }
        
        satisfactionContainer.snp.makeConstraints {
            $0.top.equalTo(satisfactionSelectionLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(120)
        }
        
        //가운데 기준 배치
        goodButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        badButton.snp.makeConstraints {
            $0.centerY.equalTo(goodButton)
            $0.trailing.equalTo(goodButton.snp.leading).offset(-77.5)
        }
        
        greatButton.snp.makeConstraints {
            $0.centerY.equalTo(goodButton)
            $0.leading.equalTo(goodButton.snp.trailing).offset(77.5)
        }
        
        leftLine.snp.makeConstraints {
            $0.leading.equalTo(badButton.circleButton.snp.trailing).offset(4)
            $0.trailing.equalTo(goodButton.circleButton.snp.leading).offset(-4)
            $0.centerY.equalTo(badButton.circleButton)
            $0.height.equalTo(2)
        }
        
        rightLine.snp.makeConstraints {
            $0.leading.equalTo(goodButton.circleButton.snp.trailing).offset(4)
            $0.trailing.equalTo(greatButton.circleButton.snp.leading).offset(-4)
            $0.centerY.equalTo(goodButton.circleButton)
            $0.height.equalTo(2)
        }
        
        rapidReviewSelectionLabel.snp.makeConstraints {
            $0.top.equalTo(satisfactionContainer.snp.bottom).offset(28)
            $0.leading.equalToSuperview().inset(16)
        }
        
        rapidReviewChipContainer.snp.makeConstraints {
            $0.top.equalTo(rapidReviewSelectionLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        reviewDescription.snp.makeConstraints {
            $0.top.equalTo(rapidReviewChipContainer.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(16)
        }
        
        reviewTextView.snp.makeConstraints {
            $0.top.equalTo(reviewDescription.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(120)
        }
        
        submitButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(47)
        }
    }
    
    func updateSatisfaction(_ level: SatisfactionLevel) {
        selectedSatisfaction = level
        
        //하나만 선택하기 위해
        [badButton, goodButton, greatButton].forEach {
            $0.setSelected(false)
        }
        
        switch level {
        case .bad:
            badButton.setSelected(true)
        case .good:
            goodButton.setSelected(true)
        case .great:
            greatButton.setSelected(true)
        }
    }
}
