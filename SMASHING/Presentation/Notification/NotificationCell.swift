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
    
    private let profileImageView = UIImageView().then {
        $0.backgroundColor = .systemGray5
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(.textSmSb)
        $0.textColor = .Text.primary
    }
    
    private let timeLabel = UILabel().then {
        $0.font = .pretendard(.textSmSb)
        $0.textColor = .Text.primary
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .pretendard(.textSmSb)
        $0.textColor = .Text.primary
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .Border.primary
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        contentView.addSubviews(profileImageView, titleLabel, timeLabel, contentLabel, dividerView)
    }
    
    func setLayouts() {
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(12)
            $0.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
            $0.top.equalTo(profileImageView)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(3)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func configure(notification: NotificationSummaryResponseDTO) {
        profileImageView.image = UIImage.defaultProfileImage(name: notification.senderNickname)
        titleLabel.text = notification.senderNickname
        contentLabel.text = notification.content
    }
}
