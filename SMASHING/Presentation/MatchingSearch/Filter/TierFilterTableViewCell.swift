//
//  TierFilterTableViewCell.swift
//  SMASHING
//
//  Created by JIN on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class TierFilterTableViewCell: BaseUITableViewCell, ReuseIdentifiable {

    // MARK: - UI Components

    private let tierLabel = UILabel().then {
        $0.font = .pretendard(.textSmM)
        $0.textColor = .Text.secondary
    }

    // MARK: - Setup Methods

    override func setUI() {
        backgroundColor = .Background.surface
        selectionStyle = .none
        contentView.addSubviews(tierLabel)
    }

    override func setLayout() {
        tierLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
    }

    // MARK: - Configuration

    func configure(tier: Tier, isSelected: Bool) {
        self.tierLabel.text = tier.simpleDisplayName

        if isSelected {
            self.contentView.backgroundColor = .Background.surfacePressed
            self.tierLabel.textColor = .Text.primary
        } else {
            self.contentView.backgroundColor = .Background.surface
            self.tierLabel.textColor = .Text.secondary
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.tierLabel.text = nil
        self.contentView.backgroundColor = .Background.surface
    }
}
