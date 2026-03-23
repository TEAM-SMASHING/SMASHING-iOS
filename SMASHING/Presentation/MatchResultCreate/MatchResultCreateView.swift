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
    private var selectedWinner: String?
    
    var onBackTapped: (() -> Void)?
    
    lazy var navigationBar = CustomNavigationBar(title: "결과 작성",
                                                 leftAction: { [weak self] in
        self?.onBackTapped?()})
    
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
    
    private let matchResultCard = MatchResultCardView()
    
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
        $0.titleLabel?.setPretendard(.textSmM)
        $0.setTitleColor(.Text.primary, for: .normal)
    }
    
    let rivalOptionButton = UIButton().then {
        $0.setTitle("와구와구", for: .normal)
        $0.titleLabel?.setPretendard(.textSmM)
        $0.setTitleColor(.Text.primary, for: .normal)
    }
    
    let nextButton = CTAButton(label: "다음")
    
    override func setUI() {
        dropDownOptionsView.addSubviews(myOptionButton, rivalOptionButton)
        
        addSubviews(navigationBar,
                    titleLabel,
                    subTitleLabel,
                    matchResultCard,
                    winnerLabel,
                    winnerRequiredStar,
                    winnerDropDown,
                    nextButton,
                    dropDownOptionsView)
        
        nextButton.isEnabled = false
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
        
        matchResultCard.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(16)
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
            $0.top.equalTo(matchResultCard.snp.bottom).offset(20)
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
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(47)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(46)
        }
    }
    
    // MARK: UI Methods
    
    // 토글 드롭다운 뷰
    func toggleDropDown() {
        isDropDownExpanded.toggle()
        
        let targetHeight: CGFloat = self.isDropDownExpanded ? 96 : 0
        
        dropDownHeightConstraint?.update(offset: targetHeight)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.layoutIfNeeded()
        }
    }
    
    func updateSelectedWinner(_ winner: String) {
        selectedWinner = winner
        winnerDropDown.updateSelectedWinner(winner)
        if isDropDownExpanded {
            toggleDropDown()
        }
        updateWinnerUI()
    }
    
    private func updateWinnerUI() {
        guard let selectedWinner else { return }
        
        let isMyWin = (selectedWinner == myOptionButton.titleLabel?.text)
        matchResultCard.updateWinnerCrown(isMyWin: isMyWin)
    }
    
    // MARK: - Configure
    func configure(myNickname: String, opponentNickname: String) {
        myOptionButton.setTitle(myNickname, for: .normal)
        rivalOptionButton.setTitle(opponentNickname, for: .normal)
        matchResultCard.configure(myName: myNickname, myImage: UIImage(systemName: "circle.fill"), rivalName: opponentNickname, rivalImage: UIImage(systemName: "circle.fill"))
    }
    
    func getSelectedWinner() -> String? {
        return selectedWinner
    }
}
