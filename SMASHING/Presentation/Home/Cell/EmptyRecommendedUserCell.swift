//
//  EmptyRecommendedUserCell.swift
//  SMASHING
//
//  Created by 홍준범 on 1/23/26.
//

import UIKit
import Combine

import SnapKit
import Then

final class EmptyRecommendedUserCell: BaseUICollectionViewCell, ReuseIdentifiable {
    private let containerView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 8
    }
    
    private let messageLabel = UILabel().then {
        $0.setPretendard(.textMdM)
        $0.textColor = .Text.tertiary
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.text = "아직 동네 유저가 없어요"
    }
    
    override func setUI() {
        containerView.addSubviews(messageLabel)
        
        contentView.addSubview(containerView)
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
