//
//  SportsButtonCell.swift
//  SMASHING
//
//  Created by 이승준 on 1/20/26.
//

import UIKit

import SnapKit

final class SportsButtonCell: BaseUICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - Properties
    
    var sportsAction: ((Sports?) -> Void)?
    private var sports: Sports?
    private var chip: SportsButtonChip?
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        chip?.removeFromSuperview()
        chip = nil
        sportsAction = nil
    }
    
    // MARK: - Configuration
    
    func configure(with sports: Sports?, isSelected: Bool) {
        self.sports = sports
        let newChip = SportsButtonChip(sports: sports, selected: isSelected)
        self.chip = newChip
        
        newChip.isUserInteractionEnabled = true
        newChip.addTarget(self, action: #selector(chipTapped), for: .touchUpInside)
        
        contentView.addSubview(newChip)
        newChip.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    
    @objc private func chipTapped() {
        sportsAction?(sports)
    }
}
