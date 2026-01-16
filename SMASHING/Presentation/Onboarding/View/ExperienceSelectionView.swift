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
    
    var action: ((SportsExperienceType) -> Void)?
    private var buttons: [TierButton] = []
    
    private let tierOptions: [SportsExperienceType] = [.lt3Months, .lt6Months, .lt1Year,
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
            let button = TierButton(tier: tier)
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
    
    func configure(action: @escaping (SportsExperienceType) -> Void) {
        self.action = action
    }
    
    // MARK: - Actions
    
    @objc private func buttonTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedButton = sender.view as? TierButton else { return }
        
        buttons.forEach { $0.isSelected = ($0 === selectedButton) }
        
        action?(selectedButton.getTier())
    }
}
