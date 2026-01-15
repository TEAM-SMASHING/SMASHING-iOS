//
//  TierChipCell.swift
//  SMASHING
//
//  Created by 이승준 on 1/16/26.
//

import UIKit

import SnapKit
import Then

final class TierChipCell : BaseUICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - Properties
    
    static let horizontalPadding: CGFloat = 16
    
    // MARK: - UI Components
    
    private let label = UILabel().then {
        $0.font = .pretendard(.textSmR)
        $0.textColor = .Text.secondary
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = false
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        layer.borderColor = UIColor.Text.secondary.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 20
        clipsToBounds = true
        addSubview(label)
    }
    
    override func setLayout() {
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: Public Methods
    
    func selected() {
        backgroundColor = .Background.canvasReverse
        layer.borderColor = UIColor.Background.canvasReverse.cgColor
        label.textColor = .Text.primaryReverse
    }
    
    func deselected() {
        backgroundColor = .Background.canvas
        layer.borderColor = UIColor.Text.primary.cgColor
        label.textColor = .Text.primary
    }
    
    func configure(with tier: OreTier) {
        label.text = tier.rawValue
    }
}
