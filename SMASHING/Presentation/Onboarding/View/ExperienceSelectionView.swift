//
//  TierSelectionView.swift
//  SMASHING
//
//  Created by 이승준 on 1/11/26.
//

import UIKit

import SnapKit
import Then

final class ExperienceSelectionView: BaseUIView {
    
    // MARK: - Properties
    
    var action: ((ExperienceRange) -> Void)?
    private var buttons: [ExperienceRangeButton] = []
    
    private let tierOptions: [ExperienceRange] = [.lt3Months, .lt6Months, .lt1Year,
                                                    .lt1_6Years, .gte2Years]
        
    // MARK: - UI Components
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        addSubview(stackView)
        
        tierOptions.forEach { tier in
            let button = ExperienceRangeButton(tier: tier)
            button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:))))
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.height.equalTo(232)
        }
    }
    
    func configure(action: @escaping (ExperienceRange) -> Void) {
        self.action = action
    }
    
    func handleSelection(for experienceRange: ExperienceRange) {
        buttons.first{ $0.getExperienceRange() == experienceRange }?.isSelected = true
    }
    
    // MARK: - Actions
    
    @objc private func buttonTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedButton = sender.view as? ExperienceRangeButton else { return }
        
        buttons.forEach { $0.isSelected = ($0 === selectedButton) }
        
        action?(selectedButton.getExperienceRange())
    }
}
