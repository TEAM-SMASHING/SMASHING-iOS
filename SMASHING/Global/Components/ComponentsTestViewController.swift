//
//  ComponentsTestViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/7/26.
//

import Foundation

import UIKit

import SnapKit
import Then

class TestViewController: UIViewController {
    
    private lazy var customBar = CustomNavigationBar(
        title: "타이틀",
        leftAction: { [weak self] in
            self?.smashingTextField.text = "타이틀"
        }).then {
            $0.setRightButton(image: .icBell, action: {
                print("알림창으로 이동")
            })
        }
    
    let smashingTextField = CommonTextField()
    
    let smashingTextField1 = CommonTextField().then {
        $0.hideClearButtonAlways()
    }
    
    lazy var nextButton = CTAButton(
        label: "에러 발생",
        action: { [weak self] in
            self?.smashingTextField1.setError(message: "에러 메시지입니다.")
        }
    )
    
    lazy var resetToDefaultButton = CTAButton(
        label: "resetToDefault()",
        action: { [weak self] in
            self?.smashingTextField1.resetToDefault()
        }
    )
    
    let disabledButton = CTAButton(
        label: "Disabled"
    ).then {
        $0.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Background.canvas
        
        self.hideKeyboardWhenDidTap()
        
        self.view.addSubview(customBar)
        self.view.addSubview(smashingTextField)
        self.view.addSubview(smashingTextField1)
        self.view.addSubview(nextButton)
        self.view.addSubview(resetToDefaultButton)
        self.view.addSubview(disabledButton)
        
        customBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        smashingTextField.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        smashingTextField1.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(smashingTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(smashingTextField1.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        resetToDefaultButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nextButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        disabledButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(resetToDefaultButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

import SwiftUI
@available(iOS 18.0, *)
#Preview {
    TestViewController()
}
