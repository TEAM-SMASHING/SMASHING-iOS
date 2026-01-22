//
//  TopThreePodium.swift
//  SMASHING
//
//  Created by 홍준범 on 1/15/26.
//

import UIKit
import Combine

import SnapKit
import Then

final class TopThreePodium: BaseUIView {
    
    // MARK: - UI Components
    
    // 왕관(1등 전용)
    private let crownImageView = UIImageView().then {
        $0.image = .icCrown
        $0.contentMode = .scaleAspectFit
    }
    
    // 2등 (왼쪽)
    private let secondProfileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    private let secondNicknameLabel = UILabel().then {
        $0.setPretendard(.textSmM)
        $0.textColor = .Text.primary
        $0.textAlignment = .center
    }
    
    private let secondCard = RankingCardView()
    
    // 1등 (중앙)
    private let firstProfileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    private let firstNicknameLabel = UILabel().then {
        $0.setPretendard(.textSmM)
        $0.textColor = .Text.primary
        $0.textAlignment = .center
    }
    
    private let firstCard = RankingCardView()
    
    // 3등 (오른쪽)
    private let thirdProfileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    private let thirdNicknameLabel = UILabel().then {
        $0.setPretendard(.textSmM)
        $0.textColor = .Text.primary
        $0.textAlignment = .center
    }
    
    private let thirdCard = RankingCardView()
    
    
    // MARK: - Setup Methods
    
    override func setUI() {
        addSubviews(crownImageView,
                    secondProfileImageView,
                    secondCard,
                    firstProfileImageView,
                    firstNicknameLabel,
                    firstCard,
                    thirdProfileImageView,
                    thirdNicknameLabel,
                    secondNicknameLabel,
                    thirdCard
        )
    }
    
    override func setLayout() {
        // MARK: - 2등 (왼쪽)
        
        secondProfileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(47.5)
            $0.centerX.equalTo(secondCard)
            $0.size.equalTo(40)
        }
        
        secondNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(secondProfileImageView.snp.bottom).offset(4)
            $0.centerX.equalTo(secondCard)
        }
        
        secondCard.snp.makeConstraints {
            $0.top.equalTo(secondNicknameLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(firstCard.snp.leading)
            $0.height.equalTo(111)
            $0.bottom.equalToSuperview()
        }
        
        // MARK: - 1등 (중앙)
        
        crownImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        firstProfileImageView.snp.makeConstraints {
            $0.top.equalTo(crownImageView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(40)
        }
        
        firstNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(firstProfileImageView.snp.bottom).offset(4)
            $0.centerX.equalTo(firstProfileImageView)
        }
        
        firstCard.snp.makeConstraints {
            $0.top.equalTo(firstNicknameLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(130)
            $0.width.equalTo(117)
            $0.bottom.equalToSuperview()
        }
        
        // MARK: - 3등 (오른쪽)
        
        thirdProfileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(51)
            $0.centerX.equalTo(thirdCard)
            $0.size.equalTo(40)
        }
        
        thirdNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(thirdProfileImageView.snp.bottom).offset(4)
            $0.centerX.equalTo(thirdCard)
        }
        
        thirdCard.snp.makeConstraints {
            $0.top.equalTo(thirdNicknameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(firstCard.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(103)
        }
    }
    
    // MARK: - Public Methods
    
    func configure(with user: RankingUserDTO) {
        switch user.rank {
        case 1:
            firstNicknameLabel.text = user.nickname
            firstProfileImageView.image = UIImage.defaultProfileImage(name: user.nickname)
            firstCard.configure(rankImage: .icRank1, tierCode: user.tierCode, lp: user.lp)
            firstProfileImageView.layer.borderColor = UIColor.Border.primary.cgColor
            firstProfileImageView.layer.borderWidth = 1
            crownImageView.isHidden = false
        case 2:
            secondNicknameLabel.text = user.nickname
            secondProfileImageView.image = UIImage.defaultProfileImage(name: user.nickname)
            secondCard.configure(rankImage: .icRank2, tierCode: user.tierCode, lp: user.lp)
            secondProfileImageView.layer.borderColor = UIColor.Border.primary.cgColor
            secondProfileImageView.layer.borderWidth = 1
        case 3:
            thirdNicknameLabel.text = user.nickname
            thirdProfileImageView.image = UIImage.defaultProfileImage(name: user.nickname)
            thirdCard.configure(rankImage: .icRank3, tierCode: user.tierCode, lp: user.lp)
            thirdProfileImageView.layer.borderColor = UIColor.Border.primary.cgColor
            thirdProfileImageView.layer.borderWidth = 1
        default:
            break
        }
    }
}
