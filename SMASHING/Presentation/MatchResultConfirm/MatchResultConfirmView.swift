//
//  MatchResultConfirmView.swift
//  SMASHING
//
//  Created by 홍준범 on 1/21/26.
//

import UIKit

import SnapKit
import Then

final class MatchResultConfirmView: BaseUIView {
    private let navigationBar = CustomNavigationBar(title: "결과 확인")
    
    private let titleLabel = UILabel().then {
        $0.text = "경기 결과를 확인해주세요"
        $0.setPretendard(.titleXlSb)
        $0.textColor = .Text.primary
    }
    
    let matchResultCard = MatchResultCardView()
    
    // MARK: - 승자 영역
    
    private let winnerLabel = UILabel().then {
        $0.text = "승자"
        $0.setPretendard(.textMdM)
        $0.textColor = .Text.primary
    }
    
    private let winnerRequiredStar = UILabel().then {
        $0.text = "*"
        $0.setPretendard(.textMdM)
        $0.textColor = .Text.red
    }
    
    private let winnerValueView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 8
    }
    
    private let winnerValueLabel = UILabel().then {
        $0.text = "-"
        $0.setPretendard(.textMdM)
        $0.textColor = .Text.primary
        $0.textAlignment = .center
    }
    
    // MARK: - 스코어 영역
    
    private let scoreLabel = UILabel().then {
        $0.text = "스코어"
        $0.setPretendard(.textMdM)
        $0.textColor = .Text.primary
    }
    
    private let scoreRequiredStar = UILabel().then {
        $0.text = "*"
        $0.setPretendard(.textMdM)
        $0.textColor = .Text.red
    }
    
    private let myScoreView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 8
    }
    
    private let myScoreLabel = UILabel().then {
        $0.text = "0"
        $0.setPretendard(.textMdM)
        $0.textColor = .Text.primary
        $0.textAlignment = .center
    }
    
    private let scoreSemicolonLabel = UILabel().then {
        $0.text = ":"
        $0.setPretendard(.textSmM)
        $0.textColor = .Text.primary
    }
    
    private let opponentScoreView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 8
    }
    
    private let opponentScoreLabel = UILabel().then {
        $0.text = "0"
        $0.setPretendard(.textMdM)
        $0.textColor = .Text.primary
        $0.textAlignment = .center
    }
    
    // MARK: - 하단 버튼 영역
    
    private let confirmQuestionLabel = UILabel().then {
        $0.text = "경기 결과가 일치하나요?"
        $0.setPretendard(.textSmM)
        $0.textColor = .Text.secondary
        $0.textAlignment = .center
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.distribution = .fillProportionally
    }
    
    let rejectButton = UIButton().then {
        $0.setTitle("아니요", for: .normal)
        $0.setTitleColor(.Button.textSecondaryActive, for: .normal)
        $0.titleLabel?.font = .pretendard(.textMdSb)
        $0.backgroundColor = .Button.backgroundPrimaryDisabled
        $0.layer.cornerRadius = 12
    }
    
    let confirmButton = UIButton().then {
        $0.setTitle("네, 맞아요", for: .normal)
        $0.setTitleColor(.Text.primaryReverse, for: .normal)
        $0.titleLabel?.font = .pretendard(.textMdSb)
        $0.backgroundColor = .Button.backgroundPrimaryActive
        $0.layer.cornerRadius = 12
    }
    
    override func setUI() {
        backgroundColor = .clear
        winnerValueView.addSubview(winnerValueLabel)
        myScoreView.addSubview(myScoreLabel)
        opponentScoreView.addSubview(opponentScoreLabel)
        buttonStackView.addArrangedSubviews(rejectButton, confirmButton)
        
        addSubviews(navigationBar,
                    titleLabel,
                    matchResultCard,
                    winnerLabel,
                    winnerRequiredStar,
                    winnerValueView,
                    scoreLabel,
                    scoreRequiredStar,
                    myScoreView,
                    scoreSemicolonLabel,
                    opponentScoreView,
                    confirmQuestionLabel,
                    buttonStackView)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.equalToSuperview().inset(16)
        }
        
        matchResultCard.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(160)
        }
        
        // 승자 영역
        winnerLabel.snp.makeConstraints {
            $0.centerY.equalTo(winnerValueView)
            $0.leading.equalToSuperview().inset(16)
        }
        
        winnerRequiredStar.snp.makeConstraints {
            $0.centerY.equalTo(winnerValueView)
            $0.leading.equalTo(winnerLabel.snp.trailing)
        }
        
        winnerValueView.snp.makeConstraints {
            $0.top.equalTo(matchResultCard.snp.bottom).offset(20)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(140)
            $0.height.equalTo(45)
        }
        
        winnerValueLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        // 스코어 영역
        scoreLabel.snp.makeConstraints {
            $0.top.equalTo(winnerLabel.snp.bottom).offset(41)
            $0.leading.equalToSuperview().inset(16)
        }
        
        scoreRequiredStar.snp.makeConstraints {
            $0.top.equalTo(scoreLabel)
            $0.leading.equalTo(scoreLabel.snp.trailing)
        }
        
        myScoreView.snp.makeConstraints {
            $0.centerY.equalTo(scoreLabel)
            $0.leading.equalTo(winnerValueView.snp.leading)
            $0.width.equalTo(56)
            $0.height.equalTo(45)
        }
        
        myScoreLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        scoreSemicolonLabel.snp.makeConstraints {
            $0.centerY.equalTo(scoreLabel)
            $0.leading.equalTo(myScoreView.snp.trailing).offset(12)
        }
        
        opponentScoreView.snp.makeConstraints {
            $0.centerY.equalTo(scoreLabel)
            $0.trailing.equalTo(winnerValueView.snp.trailing)
            $0.width.height.equalTo(myScoreView)
        }
        
        opponentScoreLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        // 하단 버튼 영역
        confirmQuestionLabel.snp.makeConstraints {
            $0.bottom.equalTo(buttonStackView.snp.top).offset(-16)
            $0.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(47)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(46)
        }
        
        rejectButton.snp.makeConstraints {
            $0.width.equalTo(confirmButton).multipliedBy(0.55)
        }
    }
    
    // MARK: - Configure
    
    func configure(
        myNickname: String,
        opponentNickname: String,
        myScore: Int,
        opponentScore: Int,
        winnerNickname: String
    ) {
        matchResultCard.configure(
            myName: myNickname,
            myImage: UIImage(systemName: "circle.fill"),
            rivalName: opponentNickname,
            rivalImage: UIImage(systemName: "circle.fill")
        )
        matchResultCard.updateScore(myScore: "\(myScore)", rivalScore: "\(opponentScore)")
        
        let isMyWin = (winnerNickname == myNickname)
        matchResultCard.updateWinnerCrown(isMyWin: isMyWin)
        
        winnerValueLabel.text = winnerNickname
        myScoreLabel.text = "\(myScore)"
        opponentScoreLabel.text = "\(opponentScore)"
    }
}
