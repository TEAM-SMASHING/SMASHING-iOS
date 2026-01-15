//
//  SearchResultView.swift
//  SMASHING
//
//  Created by JIN on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class SearchResultView: BaseUIView {

    // MARK: - UI Components

    private let backButtonContainer = UIView().then {
        $0.backgroundColor = .clear
    }

    private let backButtonIcon = UIImageView().then {
        $0.image = UIImage(resource: .icArrowLeft)
        $0.contentMode = .scaleAspectFit
    }

    let searchTextField = SearchTextField().then {
        $0.setPlaceholder(text: "닉네임을 입력해주세요")
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .search
    }

    let tableView = UITableView().then {
        $0.backgroundColor = .Background.canvas
        $0.separatorStyle = .none
        $0.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "SearchResultCell"
        )
    }

    // MARK: - Properties

    var onBackButtonTapped: (() -> Void)?

    // MARK: - Setup Methods

    override func setUI() {
        backgroundColor = .Background.canvas
        addSubviews(backButtonContainer, searchTextField, tableView)
        backButtonContainer.addSubview(backButtonIcon)
    }

    override func setLayout() {
        backButtonContainer.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(24)
        }

        backButtonIcon.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(24)
        }

        searchTextField.snp.makeConstraints {
            $0.centerY.equalTo(backButtonContainer)
            $0.leading.equalTo(backButtonContainer.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func setGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(backButtonDidTap)
        )
        backButtonContainer.addGestureRecognizer(tapGesture)
    }

    // MARK: - Actions

    @objc private func backButtonDidTap() {
        onBackButtonTapped?()
    }

}
