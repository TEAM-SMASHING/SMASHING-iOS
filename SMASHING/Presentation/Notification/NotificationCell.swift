//
//  NotificationCell.swift
//  SMASHING
//
//  Created by 이승준 on 1/15/26.
//

import UIKit

import SnapKit
import Then

struct TempNotification {
    let name: String
    let type: NotificationType
    let tier: Tier?
    let isNew: Bool
    let time: String
}

final class NotificationCell: BaseUICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - Properties
    
    private var notification: TempNotification?
    
    // MARK: - UI Components
    
    private let profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .Background.overlay
    }
    
    private let typeLabel = UILabel().then {
        $0.font = .pretendard(.textMdSb)
        $0.numberOfLines = 1
        $0.textColor = .Text.primary
    }
    
    private let timeLabel = UILabel().then {
        $0.font = .pretendard(.textSmSb)
        $0.numberOfLines = 1
        $0.textColor = .Text.tertiary
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .pretendard(.textSmM)
        $0.numberOfLines = 0
        $0.textColor = .Text.secondary
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        contentView.addSubviews(profileImage, typeLabel, timeLabel, contentLabel)
    }
    
    override func setLayout() {
        profileImage.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(12)
        }
        
        typeLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImage.snp.trailing).offset(12)
            $0.top.equalToSuperview().offset(12)
            $0.trailing.lessThanOrEqualTo(timeLabel.snp.leading).offset(-8)
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(typeLabel)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom).offset(4)
            $0.leading.equalTo(typeLabel)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(notification: TempNotification) {
        typeLabel.text = notification.type.rawValue
        timeLabel.text = "10:00 AM"
        contentLabel.text = "'와쿠와쿠' 님이 소중한 후기를 보내주셨어요! 지금 확인해 볼까요 를레히히"
        backgroundColor = notification.isNew ? .clear : .Background.surface
    }
}

import SwiftUI
@available(iOS 18.0, *)
#Preview {
    NotificationViewController()
}
