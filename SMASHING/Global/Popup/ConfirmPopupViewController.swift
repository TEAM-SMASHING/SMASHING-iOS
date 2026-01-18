//
//  ConfirmPopupViewController.swift
//  SMASHING
//
//  Created by JIN on 1/18/26.
//

import UIKit

import SnapKit
import Then

final class ConfirmPopupViewController: DimmedViewController {

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

    private lazy var cancelButton = UIButton().then {
        $0.setTitleColor(.Text.primary, for: .normal)
        $0.titleLabel?.font = .pretendard(.textSmR)
        $0.backgroundColor = .Button.backgroundTeritaryActive
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
    }

    private lazy var confirmButton = UIButton().then {
        $0.setTitleColor(.Text.muted, for: .normal)
        $0.titleLabel?.font = .pretendard(.textSmR)
        $0.backgroundColor = .Button.backgroundSecondaryActive
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
    }

    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.distribution = .fillEqually
    }

    // MARK: - Properties
    
    private lazy var tapGesture = UIGestureRecognizer(target: self, action: #selector(handleBackgroundTap))

    var onCancelTapped: (() -> Void)?
    var onConfirmTapped: (() -> Void)?

    private let popupTitle: String
    private let popupMessage: String
    private let cancelTitle: String
    private let confirmTitle: String

    // MARK: - Initialize

    init(
        title: String,
        message: String,
        cancelTitle: String,
        confirmTitle: String
    ) {
        self.popupTitle = title
        self.popupMessage = message
        self.cancelTitle = cancelTitle
        self.confirmTitle = confirmTitle
        super.init()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func setUI() {
        view.addSubview(containerView)
        containerView.addSubviews(titleLabel, messageLabel, buttonStackView)
        buttonStackView.addArrangedSubviews(cancelButton, confirmButton)

        titleLabel.text = popupTitle
        messageLabel.text = popupMessage
        cancelButton.setTitle(cancelTitle, for: .normal)
        confirmButton.setTitle(confirmTitle, for: .normal)
    }

    private func setLayout() {
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }

        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(36.5)
        }

        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().offset(-24)
            $0.height.equalTo(48)
        }
    }

    // MARK: - Actions

    @objc private func cancelButtonDidTap() {
        dismiss(animated: true) { [weak self] in
            self?.onCancelTapped?()
        }
    }

    @objc private func confirmButtonDidTap() {
        dismiss(animated: true) { [weak self] in
            self?.onConfirmTapped?()
        }
    }
                                                      
    @objc private func handleBackgroundTap() {
       dismiss(animated: true)
    }
   
}
