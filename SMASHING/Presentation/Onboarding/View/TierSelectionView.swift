//
//  TierSelectionView.swift
//  SMASHING
//
//  Created by 이승준 on 1/11/26.
//

import UIKit

import SnapKit
import Then

final class TierSelectionView: BaseUIView {
    
    // MARK: - Properties
    
    private var action: ((Tier) -> Void)?
    private var buttons: [TierButton] = []
    
    private let tierOptions: [(Tier, String)] = [
        (.iron, "3개월 미만"),
        (.bronze3, "3개월 이상 ~ 6개월 미만"),
        (.bronze2, "6개월 이상 ~ 1년 미만"),
        (.bronze1, "1년 이상 ~ 1년 반 미만"),
        (.silver3, "1년 반 이상")
    ]

    // MARK: - UI Components
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        addSubview(stackView)
        
        tierOptions.forEach { option in
            let button = TierButton(tier: option.0, title: option.1)
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
    
    func configure(action: @escaping (Tier) -> Void) {
        self.action = action
    }
    
    // MARK: - Actions
    
    @objc private func buttonTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedButton = sender.view as? TierButton else { return }
        
        buttons.forEach { $0.isSelected = ($0 === selectedButton) }
        
        action?(selectedButton.getTier())
    }
}
