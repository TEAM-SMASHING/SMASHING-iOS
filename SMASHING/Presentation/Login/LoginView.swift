//
//  LoginView.swift
//  SMASHING
//
//  Created by 이승준 on 1/12/26.
//

import UIKit

import SnapKit
import Then

final class LoginView: BaseUIView {
    
    // MARK: - Properties
    
    var kakaoLoginAction: (() -> Void)?
    
    // MARK: - UI Components
    
    private let logoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .darkGray
    }
    
    private let buttonStack = UIStackView().then {
        $0.axis = .vertical
    }
    
    lazy var kakaoLoginButton = SocialLoginButton().then {
        $0.configure(logo: .icKakao, title: "카카오로 시작하기")
        $0.backgroundColor = .kakao
        $0.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
    }

    // MARK: - Setup Methods
    
    override func setUI() {
        addSubviews(logoImageView, buttonStack)
        
        buttonStack.addArrangedSubviews(kakaoLoginButton)
    }
    
    override func setLayout() {
        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        buttonStack.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-18)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(50)
        }
    }

    // MARK: - Actions
    
    @objc private func kakaoLoginButtonTapped() {
        kakaoLoginAction?()
    }
}
