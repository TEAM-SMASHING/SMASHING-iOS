//
//  RejectReasonTableViewCell.swift
//  SMASHING
//
//  Created by 홍준범 on 1/21/26.
//

import UIKit

import SnapKit
import Then

final class RejectReasonTableViewCell: BaseUITableViewCell, ReuseIdentifiable {
    // MARK: - UI Components
    
    private let reasonLabel = UILabel().then {
        $0.font = .pretendard(.textSmM)
        $0.textColor = .Text.secondary
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        backgroundColor = .Background.surface
        selectionStyle = .none
        contentView.addSubviews(reasonLabel)
    }
    
    override func setLayout() {
        reasonLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
    }
    
    // MARK: - Configuration
    
    func configure(reason: RejectReason, isSelected: Bool) {
        reasonLabel.text = reason.displayText
        
        if isSelected {
            contentView.backgroundColor = .Background.surfacePressed
            reasonLabel.textColor = .Text.primary
        } else {
            contentView.backgroundColor = .Background.surface
            reasonLabel.textColor = .Text.secondary
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reasonLabel.text = nil
        contentView.backgroundColor = .Background.surface
    }
}
