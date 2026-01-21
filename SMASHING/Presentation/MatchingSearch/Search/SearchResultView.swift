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

    private lazy var navigationBar = CustomNavigationBar(title: "").then {
        $0.setLeftButton { [weak self] in
            self?.onBackButtonTapped?()
        }
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
            SearchResultCell.self,
            forCellReuseIdentifier: SearchResultCell.reuseIdentifier
        )
    }

    // MARK: - Properties

    var onBackButtonTapped: (() -> Void)?

    // MARK: - Setup Methods

    override func setUI() {
        backgroundColor = .Background.canvas
        addSubviews(navigationBar, searchTextField, tableView)
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        searchTextField.snp.makeConstraints {
            $0.centerY.equalTo(navigationBar)
            $0.leading.equalTo(navigationBar.snp.leading).offset(50)
            $0.trailing.equalToSuperview().inset(16)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

}
