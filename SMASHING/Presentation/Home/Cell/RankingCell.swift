//
//  RankingCell.swift
//  SMASHING
//
//  Created by 홍준범 on 1/11/26.
//

import UIKit

import Then
import SnapKit

final class RankingCell: BaseUICollectionViewCell, ReuseIdentifiable {
    private let containerView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 8
    }
    
    private let tierImageView = UIImageView().then {
        $0.image = .icGold
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    private let rankLabel = UILabel().then {
        $0.text = "4"
        $0.textColor = .Text.primary
        $0.font = .pretendard(.textSmM)
        $0.textAlignment = .center
    }
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(systemName: "circle.fill")
        $0.contentMode = .scaleAspectFill
        $0.tintColor = .white
    }
    
    private let nameAndTierStackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "조동현"
        $0.setPretendard(.textSmM)
        $0.textColor = .Text.primary
    }
    
    private let tierLabel = UILabel().then {
        $0.text = "Platinum II · 1430P"
        $0.setPretendard(.captionXsR)
        $0.textColor = .Text.tertiary
    }
    
    private let tierEmblem = UIImageView().then {
        $0.image = UIImage(systemName: "circle.fill")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
    }
    
    override func setUI() {
        nameAndTierStackView.addArrangedSubviews(nameLabel, tierLabel)
        
        containerView.addSubviews(tierImageView, rankLabel, profileImageView, nameAndTierStackView, tierEmblem)
        
        contentView.addSubview(containerView)
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tierImageView.snp.makeConstraints {
            $0.leading.equalTo(containerView.snp.leading).inset(21)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        rankLabel.snp.makeConstraints {
            $0.leading.equalTo(containerView.snp.leading).inset(21)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(tierImageView.snp.trailing).offset(8)
            $0.size.equalTo(40)
        }
        
        nameAndTierStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        tierEmblem.snp.makeConstraints {
            $0.trailing.equalTo(containerView.snp.trailing).inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(30)
        }
    }
    
    func configureAllRankingView(with ranker: RankingUserDTO) {
        tierImageView.isHidden = true
        rankLabel.text = ranker.rank.description
        nameLabel.text = ranker.nickname
        tierLabel.text = ranker.tierWithLpText
    }
}
