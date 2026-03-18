//
//  MtPageView.swift
//  SMASHING
//
//  Created by 이승준 on 2/27/26.
//

import UIKit

import Then
import SnapKit

final class SignOutView: BaseUIView {
    
    // MARK: - Properties

    var leftButtonAction: (() -> Void)?
    var checkboxAction: (() -> Void)?
    var signoutAction: (() -> Void)?
    private let deletedInfos = ["프로필 및 계정 정보", "매칭 및 경기 기록"]
    
    // MARK: - UI Components
    
    private lazy var navigationBar = CustomNavigationBar(title: "계정 탈퇴") {
        self.leftButtonAction!()
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "정말 탈퇴하시겠습니까?"
        $0.textColor = UIColor.Text.primary
        $0.font = .pretendard(.titleXlSb)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "탈퇴 시 모든 정보가 삭제되며 복구할 수 없습니다"
        $0.textColor = UIColor.Text.primary
        $0.font = .pretendard(.textMdM)
    }
    
    private lazy var profileCell = deletedInfoCell(text: "프로필 및 계정 정보")
    private lazy var matchingRecordCell = deletedInfoCell(text: "매칭 및 경기 기록")
    private lazy var reviewCell = deletedInfoCell(text: "작성한 후기 및 평가")
    private lazy var chatingCell = deletedInfoCell(text: "채팅 내역")
    private lazy var notificationCell = deletedInfoCell(text: "알림 및 차단 / 신고 내역")
    
    let checkboxButton = UIButton().then {
        $0.setImage(.icCheckboxEmpty, for: .normal)
    }
    
    private let acceptLabel = UILabel().then {
        $0.text = "주의사항을 인지하였으며, 이에 동의합니다"
        $0.textColor = .Text.primary
        $0.font = .pretendard(.textSmR)
    }
    
    private let signOutButton = CTAButton(label: "탈퇴하기", warning: true).then {
        $0.isEnabled = false
    }
    
    // MARK: - Lifecycle
    
    override func setUI() {
        addSubviews(
            navigationBar,
            titleLabel,
            subTitleLabel,
            profileCell,
            matchingRecordCell,
            reviewCell,
            chatingCell,
            notificationCell,
            checkboxButton,
            acceptLabel,
            signOutButton)
        checkboxButton.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(signoutButtonTapped), for: .touchUpInside)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(16)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
        }
        
        profileCell.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        matchingRecordCell.snp.makeConstraints { make in
            make.top.equalTo(profileCell.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        reviewCell.snp.makeConstraints { make in
            make.top.equalTo(matchingRecordCell.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        chatingCell.snp.makeConstraints { make in
            make.top.equalTo(reviewCell.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        notificationCell.snp.makeConstraints { make in
            make.top.equalTo(chatingCell.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        checkboxButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(signOutButton.snp.top).offset(-12)
        }
        
        acceptLabel.snp.makeConstraints { make in
            make.centerY.equalTo(checkboxButton)
            make.leading.equalTo(checkboxButton.snp.trailing).offset(4)
        }
        
        signOutButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(46)
            make.bottom.equalToSuperview().inset(22)
            make.width.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Public
    
    func configure(isSignOutEnabled: Bool) {
        signOutButton.isEnabled = isSignOutEnabled
    }
    
    // MARK: - Actions
    
    @objc private func checkboxTapped() {
        let isChecked = checkboxButton.image(for: .normal) == UIImage(resource: .icCheckbox)
        checkboxButton.setImage(isChecked ? .icCheckboxEmpty : .icCheckbox, for: .normal)
        checkboxAction?()
    }
    
    @objc private func signoutButtonTapped() {
        signoutAction?()
    }
    
    // MARK: - Private
    
    private func deletedInfoCell(text: String) -> UIView {
        let container = UIView().then {
            $0.backgroundColor = .Background.surface
            $0.layer.cornerRadius = 8
        }
        let infoLabel = UILabel().then {
            $0.text = text
            $0.textColor = UIColor.Text.primary
            $0.font = .pretendard(.textSmM)
        }
        
        container.addSubview(infoLabel)
        
        container.snp.makeConstraints { make in
            make.height.equalTo(51)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        return container
    }
}

import SwiftUI
@available(iOS 18.0, *)
#Preview {
    SignOutViewController()
}
