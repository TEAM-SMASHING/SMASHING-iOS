//
//  SportsSelectionView.swift
//  SMASHING
//
//  Created by 이승준 on 1/11/26.
//

import UIKit

import SnapKit
import Then

final class SportsSelectionView: BaseUIView {
    
    // MARK: - Properties
    
    private var action: ((Sports) -> Void)?
    private var chips: [SportsChip] = []

    // MARK: - UI Components
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 10
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        addSubview(stackView)
        
        [Sports.badminton, .tableTennis, .tennis].forEach { sport in
            let chip = SportsChip(sport: sport)
            chip.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chipTapped(_:))))
            chips.append(chip)
            stackView.addArrangedSubview(chip)
        }
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.height.equalTo(40)
        }
    }
    
    func configure(action: @escaping (Sports) -> Void) {
        self.action = action
    }
    
    // MARK: - Actions
    
    @objc private func chipTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedChip = sender.view as? SportsChip else { return }
        
        chips.forEach { $0.isSelected = ($0 === selectedChip) }
        
        if let sport = getSport(from: selectedChip) {
            action?(sport)
        }
    }
    
    // MARK: - Private Methods
    
    private func getSport(from chip: SportsChip) -> Sports? {
        return Mirror(reflecting: chip).children.first(where: { $0.label == "sport" })?.value as? Sports
    }
}
