//
//  EmptyMatchingCell.swift
//  SMASHING
//
//  Created by 홍준범 on 1/21/26.
//

import UIKit

import Then
import SnapKit

final class EmptyMatchingCell: BaseUICollectionViewCell, ReuseIdentifiable {
    
    var onExploreButtonTapped: (() -> Void)?
    
    private let containerView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 8
        $0.isUserInteractionEnabled = true
    }
    
    private let messageLabel = UILabel().then {
           $0.setPretendard(.textMdM)
           $0.textColor = .Text.tertiary
           $0.numberOfLines = 2
           $0.textAlignment = .center
           $0.text = "아직 확정된 매칭이 없어요.\n지금 바로 매칭을 신청해보세요!"
       }
    
    private let goToMatchingSearchButton = UIButton().then {
        $0.setTitle("매칭 탐색하러 가기", for: .normal)
        $0.titleLabel?.font = .pretendard(.textMdM)
        $0.setTitleColor(.Button.backgroundSecondaryActive, for: .normal)
        $0.backgroundColor = .Button.backgroundConfirmed
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(goToMatchingSearchButtonDidTap), for: .touchUpInside)
    }
    
    override func setUI() {
        containerView.addSubviews(messageLabel, goToMatchingSearchButton)
        
        contentView.addSubview(containerView)
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(63)
            $0.leading.trailing.equalToSuperview().inset(64)
        }
        
        goToMatchingSearchButton.snp.makeConstraints {
            $0.bottom.equalTo(containerView.snp.bottom).inset(18)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        }
    }
    
    @objc private func goToMatchingSearchButtonDidTap() {
            onExploreButtonTapped?()
        }
}
