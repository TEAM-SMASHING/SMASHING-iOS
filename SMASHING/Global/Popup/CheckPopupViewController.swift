//
//  CheckPopupViewController.swift
//  SMASHING
//
//  Created by 이승준 on 3/17/26.
//

import UIKit

import SnapKit
import Then

final class CheckPopupViewController: DimmedViewController {
    
    // MARK: - UI Components
    
    private let containerView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 16
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.primary
        $0.textAlignment = .center
    }
    
    private let messageLabel = UILabel().then {
        $0.font = .pretendard(.textSmR)
        $0.textColor = .Text.tertiary
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private lazy var confirmButton = UIButton().then {
        $0.setTitleColor(.Text.muted, for: .normal)
        $0.titleLabel?.font = .pretendard(.textSmR)
        $0.backgroundColor = .Button.backgroundSecondaryActive
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Properties
    
    private lazy var tapGesture = UITapGestureRecognizer(
        target: self,
        action: #selector(handleBackgroundTap)
    )
    
    var onCancelTapped: (() -> Void)?
    lazy var onConfirmTapped: (() -> Void)? = {
        self.dismiss(animated: true)
    }
    
    private let popupTitle: String
    private let popupMessage: String
    private let confirmTitle: String
    
    // MARK: - Initialize

    init(
        title: String,
        message: String,
        confirmTitle: String
    ) {
        self.popupTitle = title
        self.popupMessage = message
        self.confirmTitle = confirmTitle
        super.init()
        setUI()
        setLayout()
        view.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        view.addSubview(containerView)
        containerView.addSubviews(titleLabel, messageLabel, confirmButton)
        titleLabel.text = popupTitle
        messageLabel.text = popupMessage
        confirmButton.setTitle(confirmTitle, for: .normal)
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(153)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(42)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
    }
    
    // MARK: - Actions
    
    @objc private func confirmButtonDidTap() {
        dismiss(animated: true) { [weak self] in
            self?.onConfirmTapped?()
        }
    }
    
    @objc private func handleBackgroundTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !containerView.frame.contains(location) {
            dismiss(animated: true)
        }
    }
}
