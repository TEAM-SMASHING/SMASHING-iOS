//
//  NotificationCell.swift
//  SMASHING
//
//  Created by 이승준 on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class NotificationCell: UICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - UI Components
    
    private let profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    private let typeLabel = UILabel().then {
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.primary
    }
    
    private let timeLabel = UILabel().then {
        $0.font = .pretendard(.textSmSb)
        $0.textColor = .Text.tertiary
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .pretendard(.textSmM)
        $0.textColor = .Text.secondary
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .Border.primary
    }
    
    // MARK: - Setup Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        contentView.addSubviews(profileImage, typeLabel, timeLabel, contentLabel, dividerView)
    }
    
    func setLayout() {
        profileImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.size.equalTo(40)
            $0.leading.equalToSuperview().inset(16)
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(12)
        }
        
        typeLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImage.snp.trailing).offset(12)
            $0.top.equalTo(profileImage)
            $0.trailing.lessThanOrEqualTo(timeLabel.snp.leading).offset(-8)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom).offset(4)
            $0.leading.equalTo(typeLabel)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func configure(notification: NotificationSummaryResponseDTO) {
        if notification.type == .reviewReceived {
            typeLabel.text =  notification.type.displayText
        } else {
            typeLabel.text =  notification.receiverSportId.displayName + " " + notification.type.displayText
        }
        timeLabel.text = notification.createdAt.toDateFromISO8601?.toRelativeString()
        contentLabel.text = notification.content
        profileImage.image = UIImage.defaultProfileImage(name: notification.senderNickname)
        backgroundColor = notification.isRead ? .clear : .Background.surface
    }
}
