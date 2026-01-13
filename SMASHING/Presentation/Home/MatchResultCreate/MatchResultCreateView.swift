//
//  MatchResultCreateView.swift
//  SMASHING
//
//  Created by 홍준범 on 1/12/26.
//

import UIKit

import SnapKit
import Then

final class MatchResultCreateView: BaseUIView {
    
    private var dropDownHeightConstraint: Constraint?
    private var isDropDownExpanded: Bool = false
    
    private let navigationBar = CustomNavigationBar(title: "매쳥 결과 작성")
    
    private let titleLabel = UILabel().then {
        $0.text = "경기 결과를 작성해주세요"
        $0.setPretendard(.titleXlSb)
        $0.textColor = .Text.primary
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "악의적인 결과 작성 시 활동이 제한될 수 있어요"
        $0.setPretendard(.textSmM)
        $0.textColor = .Text.tertiary
    }
    
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
        $0.textColor = .Text.blue //muted 추가
        $0.textAlignment = .center
    }
    
    private let score = UILabel().then {
        $0.text = "0 : 0"
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
        $0.textColor = .Text.blue //muted 추가
        $0.textAlignment = .center
    }
    
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
    
    let winnerDropDown = WinnerDropDown()
    
    private let dropDownOptionsView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    let myOptionButton = UIButton().then {
        $0.setTitle("밤이달이", for: .normal)
        $0.titleLabel?.setPretendard(.textMdM)
        $0.setTitleColor(.Text.primary, for: .normal)
    }
    
    let rivalOptionButton = UIButton().then {
        $0.setTitle("와구와구", for: .normal)
        $0.titleLabel?.setPretendard(.textMdM)
        $0.setTitleColor(.Text.primary, for: .normal)
    }
    
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
    
    private let myScoreTextField = ScoreTextField()
    
    private let semiColonLabel = UILabel().then {
        $0.text = ":"
        $0.font = .pretendard(.textSmM)
        $0.textColor = .Text.primary
    }
    
    private let rivalScoreTextField = ScoreTextField()
    
    let nextButton = CTAButton(label: "다음")
        
    override func setUI() {
        leftProfileStackView.addArrangedSubviews(myImage, myNickName)
        
        rightProfileStackView.addArrangedSubviews(rivalImage, rivalNickName)
        
        containerView.addSubviews(leftProfileStackView, rightProfileStackView, score)
        
        dropDownOptionsView.addSubviews(myOptionButton, rivalOptionButton)
        
        addSubviews(navigationBar, titleLabel, subTitleLabel, containerView, winnerLabel, scoreLabel, winnerRequiredStar, winnerDropDown, scoreRequiredStar, nextButton, myScoreTextField, semiColonLabel, rivalScoreTextField, dropDownOptionsView)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        containerView.snp.makeConstraints {
            $0.height.equalTo(160)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        myImage.snp.makeConstraints {
            $0.size.equalTo(64)
        }
        
        leftProfileStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(containerView.snp.leading).inset(38)
        }
        
        score.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(50)
            $0.bottom.equalTo(containerView.snp.bottom).inset(68)
            $0.centerX.equalToSuperview()
        }
        
        rivalImage.snp.makeConstraints {
            $0.size.equalTo(64)
        }
        
        rightProfileStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(containerView.snp.trailing).inset(38)
        }
        
        winnerLabel.snp.makeConstraints {
            $0.centerY.equalTo(winnerDropDown)
            $0.leading.equalToSuperview().inset(16)
        }
        
        winnerRequiredStar.snp.makeConstraints {
            $0.centerY.equalTo(winnerDropDown)
            $0.leading.equalTo(winnerLabel.snp.trailing)
        }
        
        winnerDropDown.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(20)
            $0.width.equalTo(140)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        dropDownOptionsView.snp.makeConstraints {
            $0.top.equalTo(winnerDropDown.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(winnerDropDown)
            dropDownHeightConstraint = $0.height.equalTo(0).constraint
        }
        
        myOptionButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        rivalOptionButton.snp.makeConstraints {
            $0.top.equalTo(myOptionButton.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        scoreLabel.snp.makeConstraints {
            $0.top.equalTo(winnerLabel.snp.bottom).offset(41)
            $0.leading.equalToSuperview().inset(16)
        }
        
        scoreRequiredStar.snp.makeConstraints {
            $0.top.equalTo(scoreLabel)
            $0.leading.equalTo(scoreLabel.snp.trailing)
        }
        
        myScoreTextField.snp.makeConstraints {
            $0.centerY.equalTo(scoreLabel)
            $0.leading.equalTo(winnerDropDown.snp.leading)
            $0.width.equalTo(56)
            $0.height.equalTo(45)
        }
        
        semiColonLabel.snp.makeConstraints {
            $0.centerY.equalTo(scoreLabel)
            $0.leading.equalTo(myScoreTextField.snp.trailing).offset(12)
        }
        
        rivalScoreTextField.snp.makeConstraints {
            $0.centerY.equalTo(scoreLabel)
            $0.trailing.equalTo(winnerDropDown.snp.trailing)
            $0.width.height.equalTo(myScoreTextField)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(47)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(46)
        }
    }
    
    func toggleDropDown() {
        isDropDownExpanded.toggle()
        
        let targetHeight: CGFloat = self.isDropDownExpanded ? 96 : 0 //옵션 두개 높이
        
        dropDownHeightConstraint?.update(offset: targetHeight)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.layoutIfNeeded()
        }
    }
    
    func updateSelectedWinner(_ winner: String) {
        winnerDropDown.updateSelectedWinner(winner)
        if isDropDownExpanded {
            toggleDropDown()
        }
    }
}

import SwiftUI
@available(iOS 18.0, *)
#Preview {
    MatchResultCreateView()
}
