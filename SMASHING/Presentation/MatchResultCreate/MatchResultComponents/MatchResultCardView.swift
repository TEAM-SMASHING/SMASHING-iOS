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
    private var currentMyScore: Int = 0
    private var currentRivalScore: Int = 0
    
    private let containerView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 12
    }
    
    private let leftCrownImageView = UIImageView().then {
        $0.image = .icCrown
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    private let myImage = UIImageView().then {
        $0.image = UIImage(systemName: "circle.fill")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 32
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
    
    private let rightCrownImageView = UIImageView().then {
        $0.image = .icCrown
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    private let rivalImage = UIImageView().then {
        $0.image = UIImage(systemName: "circle.fill")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 32
    }
    
    private let rivalNickName = UILabel().then {
        $0.text = "와구와구"
        $0.setPretendard(.textSmM)
        $0.textColor = .Text.muted
        $0.textAlignment = .center
    }
    
    override func setUI() {
        containerView.addSubviews(leftCrownImageView,
                                  rightCrownImageView,
                                  myImage,
                                  myNickName,
                                  rivalImage,
                                  rivalNickName,
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
        
        leftCrownImageView.snp.makeConstraints {
            $0.bottom.equalTo(myImage.snp.top).offset(2)
            $0.centerX.equalTo(myImage)
            $0.size.equalTo(24)
        }
        
        myImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(36)
            $0.leading.equalToSuperview().inset(38)
            $0.size.equalTo(64)
        }
        
        myNickName.snp.makeConstraints {
            $0.top.equalTo(myImage.snp.bottom)
            $0.centerX.equalTo(myImage)
        }
        
        myScore.snp.makeConstraints {
            $0.trailing.equalTo(scoreSemicolon.snp.leading).offset(-6)
            $0.centerY.equalTo(scoreSemicolon)
        }
        
        scoreSemicolon.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(myImage)
        }
        
        rivalScore.snp.makeConstraints {
            $0.leading.equalTo(scoreSemicolon.snp.trailing).offset(6)
            $0.centerY.equalTo(scoreSemicolon)
        }
        
        rightCrownImageView.snp.makeConstraints {
            $0.bottom.equalTo(rivalImage.snp.top).offset(2)
            $0.centerX.equalTo(rivalImage)
            $0.size.equalTo(24)
        }
        
        rivalImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(36)
            $0.trailing.equalToSuperview().inset(38)
            $0.size.equalTo(64)
        }
        
        rivalNickName.snp.makeConstraints {
            $0.top.equalTo(rivalImage.snp.bottom)
            $0.centerX.equalTo(rivalImage)
        }
    }
    
    // MARK: UI Methods
    
    // 텍스트 필드에서 받은 스코어로 CardView의 스코어 갱신하기
    func updateScore(myScore: String, rivalScore: String) {
        self.currentMyScore = Int(myScore) ?? 0
        self.currentRivalScore = Int(rivalScore) ?? 0
        
        self.myScore.text = myScore
        self.rivalScore.text = rivalScore
    }
    
    // 드롭다운에서 선택한 승자에 왕관 씌우기
    func updateWinnerCrown(isMyWin: Bool) {
        leftCrownImageView.isHidden = !isMyWin
        rightCrownImageView.isHidden = isMyWin
    }
    
    func getMyScore() -> Int {
        return currentMyScore
    }
    
    func getRivalScore() -> Int {
        return currentRivalScore
    }
    
    func configure(myName: String, myImage: UIImage?, rivalName: String, rivalImage: UIImage?) {
        myNickName.text = myName
        rivalNickName.text = rivalName
        self.myImage.image = UIImage.defaultProfileImage(name: myName)
        self.rivalImage.image = UIImage.defaultProfileImage(name: rivalName)
    }
}
