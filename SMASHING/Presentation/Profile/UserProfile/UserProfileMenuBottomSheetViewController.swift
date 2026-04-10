//
//  UserProfileMenuBottomSheetViewController.swift
//  SMASHING
//

import UIKit

import SnapKit
import Then

final class UserProfileMenuBottomSheetViewController: BaseViewController {

    // MARK: - Properties

    var onReportTapped: (() -> Void)?
    var onBlockTapped: (() -> Void)?

    // MARK: - UI Components

    private lazy var reportButton = UIButton().then {
        $0.setTitle("신고하기", for: .normal)
        $0.setTitleColor(.Text.secondary, for: .normal)
        $0.titleLabel?.font = .pretendard(.textSmM)
        $0.contentHorizontalAlignment = .left
        $0.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)
    }

    private lazy var blockButton = UIButton().then {
        $0.setTitle("차단하기", for: .normal)
        $0.setTitleColor(.Text.red, for: .normal)
        $0.titleLabel?.font = .pretendard(.textSmM)
        $0.contentHorizontalAlignment = .left
        $0.addTarget(self, action: #selector(blockButtonTapped), for: .touchUpInside)
    }

    private let buttonStackView = UIStackView().then {
        $0.axis = .vertical
    }

    // MARK: - Setup Methods

    override func setUI() {
        view.backgroundColor = .Background.surface
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubviews(reportButton, blockButton)
    }

    override func setLayout() {
        buttonStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        reportButton.snp.makeConstraints {
            $0.height.equalTo(56)
        }

        blockButton.snp.makeConstraints {
            $0.height.equalTo(56)
        }
    }

    // MARK: - Actions

    @objc private func reportButtonTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onReportTapped?()
        }
    }

    @objc private func blockButtonTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onBlockTapped?()
        }
    }
}
