//
//  SkillExplanationCell.swift
//  SMASHING
//
//  Created by 이승준 on 1/16/26.
//

import UIKit

import SnapKit
import Then

final class SkillExplanationCell: BaseUICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - UI Components
    
    private let containerView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .Text.primary
        $0.font = .pretendard(.textMdSb)
        $0.numberOfLines = 1
    }
    
    private let subtitleLabel = UILabel().then {
        $0.textColor = .Text.secondary
        $0.font = .pretendard(.textSmR)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    // MARK: - Lifecycle
    
    override func setUI() {
        contentView.addSubview(containerView)
        containerView.addSubviews(titleLabel, subtitleLabel)
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(with skill: SkillExplanation) {
        titleLabel.text = skill.name
        subtitleLabel.text = skill.explanation
    }
}

