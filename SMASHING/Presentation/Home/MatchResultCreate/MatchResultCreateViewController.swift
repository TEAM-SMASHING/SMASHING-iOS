//
//  MatchResultCreateViewController.swift
//  SMASHING
//
//  Created by 홍준범 on 1/12/26.
//

import UIKit

import SnapKit
import Then

final class MatchResultCreateViewController: BaseViewController {
    private let mainView = MatchResultCreateView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAddTarget()
    }
    
    override func loadView() {
        view = mainView
    }
    
    private func setAddTarget() {
        mainView.winnerDropDown.addTarget(self, action: #selector(didTapWinnerDropDown), for: .touchUpInside)
        mainView.nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        mainView.myOptionButton.addTarget(self, action: #selector(didTapMyOptionButton), for: .touchUpInside)
        mainView.rivalOptionButton.addTarget(self, action: #selector(didTapRivalOptionButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapWinnerDropDown() {
        mainView.toggleDropDown()
    }
    
    @objc
    private func didTapNextButton() {
        print("didtapnextbutton")
        let vc = ReviewCreateViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func didTapMyOptionButton() {
        mainView.updateSelectedWinner("밤이달이")
        print("myOptionButtonTapped")
    }
    
    @objc
    private func didTapRivalOptionButton() {
        mainView.updateSelectedWinner("와구와구")
        print("rivalOptionButtonTapped")
    }
    
}
