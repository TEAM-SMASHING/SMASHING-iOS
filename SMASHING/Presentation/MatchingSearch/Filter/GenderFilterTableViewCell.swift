//
//  GenderFilterTableViewCell.swift
//  SMASHING
//
//  Created by JIN on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class GenderFilterTableViewCell: BaseUITableViewCell, ReuseIdentifiable {

    // MARK: - UI Components

    private let genderLabel = UILabel().then {
        $0.font = .pretendard(.textSmM)
        $0.textColor = .Text.secondary
    }

    // MARK: - Setup Methods

    override func setUI() {
        backgroundColor = .Background.surface
        selectionStyle = .none
        contentView.addSubviews(genderLabel)
    }

    override func setLayout() {
        genderLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
    }

    // MARK: - Configuration

    func configure(gender: String, isSelected: Bool) {
        self.genderLabel.text = gender

        if isSelected {
            self.contentView.backgroundColor = .Background.surfacePressed
            self.genderLabel.textColor = .Text.primary
        } else {
            self.contentView.backgroundColor = .Background.surface
            self.genderLabel.textColor = .Text.secondary
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.genderLabel.text = nil
        self.contentView.backgroundColor = .Background.surface
    }
}
