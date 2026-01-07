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
    
    let smashingTextField = CommonTextField()
    
    let smashingTextField1 = CommonTextField()
        .then {
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
        
        self.view.addSubview(smashingTextField)
        self.view.addSubview(smashingTextField1)
        self.view.addSubview(nextButton)
        self.view.addSubview(resetToDefaultButton)
        self.view.addSubview(disabledButton)
        
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
