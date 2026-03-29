//
//  MtPageView.swift
//  SMASHING
//
//  Created by 이승준 on 2/27/26.
//

import UIKit

import Then
import SnapKit

final class MyPageView: BaseUIView {
    
    // MARK: - Properties

    var leftButtonAction: (() -> Void)?
    var profileAction: (() -> Void)?
    var logoutAction: (() -> Void)?
    var signoutAction: (() -> Void)?
    var privacyPolicyAction: (() -> Void)?
    var termsOfServiceAction: (() -> Void)?
    
    // MARK: - UI Components
    
    private lazy var navigationBar = CustomNavigationBar(title: "마이페이지") {
        self.leftButtonAction!()
    }
    
    private let profileContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
    }
    
    private let userNameLabel = UILabel().then {
        $0.font = .pretendard(.textMdM)
        $0.textColor = .Text.primary
    }
    
    private let tierImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let profileStateStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.layer.cornerRadius = 13
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.Border.tertiary.cgColor
    }
    
    private let profileStateLabel = UILabel().then {
        $0.font = .pretendard(.captionXsM)
        $0.textColor = .Text.primary
        $0.text = "내 프로필"
    }
    
    private let accountManageContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let accountManageLabel = UILabel().then {
        $0.text = "계정 관리"
        $0.font = .pretendard(.captionXsM)
        $0.textColor = .Text.tertiary
    }
    
    private lazy var logoutButton = button(title: "로그아웃").then {
        $0.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    private lazy var signoutButton = button(title: "계정 탈퇴").then {
        $0.addTarget(self, action: #selector(signoutButtonTapped), for: .touchUpInside)
    }
    private lazy var signoutArrowButton = UIButton().then {
        $0.contentMode = .scaleAspectFit
        $0.setImage( .icArrowNext , for: .normal)
        $0.addTarget(self, action: #selector(signoutButtonTapped), for: .touchUpInside)
    }
    
    private let divider = UIView().then {
        $0.backgroundColor = UIColor.Background.surface
    }
    
    private let policyContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let policyAndInformationLabel = UILabel().then {
        $0.text = "정책 및 정보"
        $0.font = .pretendard(.captionXsM)
        $0.textColor = .Text.tertiary
    }
    
    private lazy var privacyPolicyButton = button(title: "개인정보 처리 방침").then {
        $0.addTarget(self, action: #selector(privacyPolicyButtonTapped), for: .touchUpInside)
    }
    private lazy var termsOfServiceButton = button(title: "이용약관").then {
        $0.addTarget(self, action: #selector(termsOfServiceButtonTapped), for: .touchUpInside)
    }
    private let versionLabel = UILabel().then {
        $0.text = "버전 정보"
        $0.font = .pretendard(.textSmM)
        $0.textColor = .Text.primary
    }
    private let versionInfoLabel = UILabel().then {
        $0.font = .pretendard(.textSmM)
        $0.textColor = .Text.tertiary
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
        $0.text = "ver \(version)"
    }
    
    // MARK: - Lifecycle
    
    override func setUI() {
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileContainerTapped))
        profileContainerView.addGestureRecognizer(profileTap)
        profileContainerView.isUserInteractionEnabled = true

        addSubviews(navigationBar, profileContainerView)
        profileContainerView.addSubviews(profileImageView,
                                         userNameLabel,
                                         tierImage,
                                         profileStateStack)
        profileStateStack.addArrangedSubview(profileStateLabel)
        addSubview(accountManageContainerView)
        accountManageContainerView.addSubviews(accountManageLabel,
                                               logoutButton,
                                               signoutButton,
                                               signoutArrowButton)
        addSubviews(divider, policyContainerView)
        policyContainerView.addSubviews(policyAndInformationLabel,
                                        privacyPolicyButton,
                                        termsOfServiceButton,
                                        versionLabel,
                                        versionInfoLabel)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        profileContainerView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.width.equalTo(60)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        
        tierImage.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
            make.height.equalTo(24)
            make.width.equalTo(67)
        }
        
        profileStateStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(26)
            make.width.equalTo(77)
        }
        
        accountManageContainerView.snp.makeConstraints { make in
            make.top.equalTo(profileContainerView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(97)
        }
        
        accountManageLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(accountManageLabel.snp.bottom).offset(19.5)
        }
        
        signoutButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(8)
            make.leading.equalToSuperview()
        }
        
        signoutArrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(signoutButton)
            make.trailing.equalToSuperview()
            make.size.equalTo(24)
        }
        
        divider.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(accountManageContainerView.snp.bottom).offset(26)
        }
        
        policyContainerView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(26)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(140)
        }
        
        policyAndInformationLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        
        privacyPolicyButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(policyAndInformationLabel.snp.bottom).offset(16)
        }
        
        termsOfServiceButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(privacyPolicyButton.snp.bottom).offset(8)
        }
        
        versionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(termsOfServiceButton.snp.bottom).offset(16)
        }
        
        versionInfoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(versionLabel)
            make.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Actions

    @objc private func profileContainerTapped() {
        profileAction?()
    }

    @objc private func logoutButtonTapped() {
        logoutAction?()
    }

    @objc private func signoutButtonTapped() {
        signoutAction?()
    }

    @objc private func privacyPolicyButtonTapped() {
        privacyPolicyAction?()
    }

    @objc private func termsOfServiceButtonTapped() {
        termsOfServiceAction?()
    }

    func configure(profile: MyProfileListResponse) {
        userNameLabel.text = profile.nickname
        tierImage.image = Tier.from(tierCode: profile.activeProfile.tierCode)?.image
        profileImageView.image = UIImage.defaultProfileImage(name: profile.nickname)
    }

    private func button(title: String) -> UIButton {
        return UIButton().then {
            $0.titleLabel?.font = .pretendard(.textSmM)
            $0.setTitleColor(.Text.primary, for: .normal)
            $0.setTitle(title, for: .normal)
        }
    }
}
