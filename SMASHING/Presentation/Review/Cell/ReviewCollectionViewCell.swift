//
//  ReviewCollectionViewCell.swift
//  SMASHING
//
//  Created by 이승준 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class ReviewCollectionViewCell: UICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - UI Components
    
    private let profileImageView = UIImageView().then {
        $0.backgroundColor = .systemGray5
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    private let nicknameLabel = UILabel().then {
        $0.font = .pretendard(.textSmSb)
        $0.textColor = .Text.primary
    }
    
    private let dateLabel = UILabel().then {
        $0.font = .pretendard(.textSmM)
        $0.textColor = .Text.secondary
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .pretendard(.textSmM)
        $0.textColor = .Text.primary
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .Border.primary
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setUI() {
        contentView.addSubviews(profileImageView, nicknameLabel, dateLabel, contentLabel, dividerView
        )
    }
    
    private func setLayouts() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.size.equalTo(40)
            $0.leading.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(nicknameLabel)
            $0.leading.equalTo(nicknameLabel.snp.trailing).offset(8)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(nicknameLabel)
            $0.trailing.equalToSuperview()
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func configure(_ review :RecentReviewResult) {
        profileImageView.image = UIImage.defaultProfileImage(name: review.opponentNickname)
        nicknameLabel.text = review.opponentNickname
        dateLabel.text = review.createdAt.toDateFromISO8601?.toRelativeString()
        contentLabel.text = review.content
    }
}
