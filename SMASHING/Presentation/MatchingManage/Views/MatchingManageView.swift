//
//  MatchingManageView.swift
//  SMASHING
//
//  Created by JIN on 1/16/26.
//

import UIKit

import SnapKit
import Then

final class MatchingManageView: BaseUIView {

    //MARK: - UI Components

    lazy var navigationBar = CustomNavigationBar(title: "매칭 관리") { [weak self] in
        self?.onBackButtonTapped?()
    }

    let headerView = MatchingManageHeaderView()

    let pageViewContainer = UIView()

    //MARK: - Callbacks

    var onBackButtonTapped: (() -> Void)?

    //MARK: - SetUp Methods

    override func setUI() {
        self.backgroundColor = UIColor(resource: .Background.canvas)
        navigationBar.setLeftButtonHidden(true)
        addSubviews(
            navigationBar,
            headerView,
            pageViewContainer
        )
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        headerView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        pageViewContainer.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
