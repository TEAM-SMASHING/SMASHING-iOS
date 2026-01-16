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
    
    private let leftProfileStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
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
    
    private let rightCrownImageView = UIImageView().then {
        $0.image = .icCrown
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
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
        
        containerView.addSubviews(leftCrownImageView,
                                  rightCrownImageView,
                                  leftProfileStackView,
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
        
        leftCrownImageView.snp.makeConstraints {
            $0.bottom.equalTo(leftProfileStackView.snp.top).offset(2)
            $0.centerX.equalTo(leftProfileStackView)
            $0.size.equalTo(24)
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
        
        rightCrownImageView.snp.makeConstraints {
            $0.bottom.equalTo(rightProfileStackView.snp.top).offset(2)
            $0.centerX.equalTo(rightProfileStackView)
            $0.size.equalTo(24)
        }
        
        rivalImage.snp.makeConstraints {
            $0.size.equalTo(64)
        }
        
        rightProfileStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(containerView.snp.trailing).inset(38)
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
        self.myImage.image = myImage
        self.rivalImage.image = rivalImage
    }
}
