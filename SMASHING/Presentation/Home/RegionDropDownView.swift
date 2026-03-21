//
//  RegionDropDownView.swift
//  SMASHING
//
//  Created by 홍준범 on 3/21/26.
//

import UIKit

import SnapKit
import Then

final class RegionDropDownView: BaseUIView {

    // MARK: - Callbacks

    var onCurrentRegionTapped: (() -> Void)?
    var onChangeRegionTapped: (() -> Void)?

    // MARK: - UI Components

    private let currentRegionButton = UIButton(type: .system).then {
        $0.setTitleColor(.Text.primary, for: .normal)
        $0.titleLabel?.font = .pretendard(.textMdM)
    }

    private let dividerView = UIView().then {
        $0.backgroundColor = .Border.secondary
    }

    private let changeRegionButton = UIButton(type: .system).then {
        $0.setTitle("내 지역 변경", for: .normal)
        $0.setTitleColor(.Text.primary, for: .normal)
        $0.titleLabel?.font = .pretendard(.textMdM)
    }

    // MARK: - Setup

    override func setUI() {
        backgroundColor = .Background.surface
        layer.cornerRadius = 8
        clipsToBounds = true

        addSubviews(currentRegionButton, dividerView, changeRegionButton)

        currentRegionButton.addTarget(self, action: #selector(currentRegionButtonDidTap), for: .touchUpInside)
        changeRegionButton.addTarget(self, action: #selector(changeRegionButtonDidTap), for: .touchUpInside)
    }

    override func setLayout() {
        currentRegionButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }

        dividerView.snp.makeConstraints {
            $0.top.equalTo(currentRegionButton.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(1)
        }

        changeRegionButton.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(48)
        }
    }

    // MARK: - Configure

    func configure(region: String) {
        currentRegionButton.setTitle(region, for: .normal)
    }

    // MARK: - Actions

    @objc private func currentRegionButtonDidTap() {
        onCurrentRegionTapped?()
    }

    @objc private func changeRegionButtonDidTap() {
        onChangeRegionTapped?()
    }
}
