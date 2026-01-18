//
//  TierCard.swift
//  SMASHING
//
//  Created by 이승준 on 1/15/26.
//

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
    
    private let tierBadge = UIImageView().then {
        $0.image = .tierGoldStage3
        $0.contentMode = .scaleAspectFit
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
        
        containerView.addSubviews(sportsStackView, tierImage, tierMark, progressBar, tierBadge,
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
        
        tierBadge.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(progressBar.snp.top).inset(-8)
            $0.height.equalTo(24)
            $0.width.equalTo(67)
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
