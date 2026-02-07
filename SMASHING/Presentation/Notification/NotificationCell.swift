//
//  NotificationCell.swift
//  SMASHING
//
//  Created by 이승준 on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class NotificationCollectionViewCell: UICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - UI Components
    
    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.primary
    }
    
    private let timeLabel = UILabel().then {
        $0.font = .pretendard(.captionXsR)
        $0.textColor = .Text.tertiary
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .pretendard(.textSmM)
        $0.textColor = .Text.secondary
        $0.numberOfLines = 0
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .darkGray.withAlphaComponent(0.5)
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
    
    private func setUI() {
        contentView.addSubviews(iconImageView, titleLabel, timeLabel, contentLabel, dividerView)
    }
    
    private func setLayouts() {
        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel).offset(12)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func configure(_ data: NotificationSummaryResponseDTO) {
        iconImageView.image = UIImage.defaultProfileImage(name: data.senderNickname)
        titleLabel.text = data.title
        contentLabel.text = data.content
        timeLabel.text = data.createdAt.toDateFromISO8601?.toRelativeString()
        contentView.backgroundColor = data.isRead ? .Background.canvas : .Background.surface
    }
}
