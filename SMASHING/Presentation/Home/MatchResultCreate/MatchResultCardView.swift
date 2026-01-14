//
//  MatchResultCardView.swift
//  SMASHING
//
//  Created by 홍준범 on 1/15/26.
//

import Foundation
import UIKit

import Then
import SnapKit

final class MatchResultCardView: BaseUIView {
    private let containerView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 12
    }
    
    private let leftProfileStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
    }
    
    private let myImage = UIImageView().then {
        $0.image = UIImage(systemName: "circle.fill")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
    }
    
    private let myNickName = UILabel().then {
        $0.text = "밤이달이"
        $0.setPretendard(.textSmM)
        $0.textColor = .Text.muted
        $0.textAlignment = .center
    }
    
    private let myScore = UILabel().then {
        $0.text = "0"
        $0.setPretendard(.headerHeroB)
        $0.textColor = .Text.secondary
        $0.textAlignment = .center
    }
    
    private let scoreSemicolon = UILabel().then {
        $0.text = ":"
        $0.setPretendard(.headerHeroB)
        $0.textColor = .Text.secondary
        $0.textAlignment = .center
    }
    
    private let rivalScore = UILabel().then {
        $0.text = "0"
        $0.setPretendard(.headerHeroB)
        $0.textColor = .Text.secondary
        $0.textAlignment = .center
    }
    
    private let rightProfileStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
    }
    
    private let rivalImage = UIImageView().then {
        $0.image = UIImage(systemName: "circle.fill")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
    }
    
    private let rivalNickName = UILabel().then {
        $0.text = "와구와구"
        $0.setPretendard(.textSmM)
        $0.textColor = .Text.muted
        $0.textAlignment = .center
    }
    
    override func setUI() {
        leftProfileStackView.addArrangedSubviews(myImage, myNickName)
        
        rightProfileStackView.addArrangedSubviews(rivalImage, rivalNickName)
        
        containerView.addSubviews(leftProfileStackView,
                                  rightProfileStackView,
                                  myScore,
                                  scoreSemicolon,
                                  rivalScore)
        
        addSubviews(containerView)
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(160)
        }
        
        myImage.snp.makeConstraints {
            $0.size.equalTo(64)
        }
        
        leftProfileStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(containerView.snp.leading).inset(38)
        }
        
        myScore.snp.makeConstraints {
            $0.trailing.equalTo(scoreSemicolon.snp.leading).offset(-2)
            $0.centerY.equalTo(scoreSemicolon)
        }
        
        scoreSemicolon.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(myImage)
        }
        
        rivalScore.snp.makeConstraints {
            $0.leading.equalTo(scoreSemicolon.snp.trailing).offset(2)
            $0.centerY.equalTo(scoreSemicolon)
        }
        
        rivalImage.snp.makeConstraints {
            $0.size.equalTo(64)
        }
        
        rightProfileStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(containerView.snp.trailing).inset(38)
        }
    }
    
    func updateScore(myScore: String, rivalScore: String) {
        self.myScore.text = myScore
        self.rivalScore.text = rivalScore
    }
    
    func configure(myName: String, myImage: UIImage?, rivalName: String, rivalImage: UIImage?) {
        myNickName.text = myName
        rivalNickName.text = rivalName
        self.myImage.image = myImage
        self.rivalImage.image = rivalImage
    }
}
