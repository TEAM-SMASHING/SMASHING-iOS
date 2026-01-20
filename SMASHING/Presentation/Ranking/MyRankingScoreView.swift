//
//  myRankingScoreView.swift
//  SMASHING
//
//  Created by 홍준범 on 1/16/26.
//

import UIKit
import Combine

import SnapKit
import Then

final class myRankingScoreView: BaseUIView {
    
    // MARK: - UI Components
    
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
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .Background.overlay
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        nameAndTierStackView.addArrangedSubviews(nameLabel, tierLabel)
        
        addSubviews(profileImageView, nameAndTierStackView, tierEmblem)
    }
    
    override func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(8)
            $0.size.equalTo(40)
        }
        
        nameAndTierStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        tierEmblem.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(30)
        }
    }
    
    func configure(with myRank: MyRankingDTO) {
        nameLabel.text = myRank.nickname
        tierLabel.text = myRank.tierWithLpText
    }
}
