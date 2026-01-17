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
    
    var action: ((Sports) -> Void)?
    private var chips: [SportsChip] = []
    private var selections: [Sports]

    // MARK: - UI Components
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 10
    }
    
    // MARK: - Setup Methods
    
    init(selections: [Sports] = [.badminton, .tableTennis, .tennis]) {
        self.selections = selections
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI() {
        addSubview(stackView)
        
        selections.forEach { sports in
            let chip = SportsChip(sports: sports)
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
    
    func handleSelection(for sports: Sports) {
        chips.first{ $0.getSports() == sports }?.isSelected = true
    }
    
    // MARK: - Actions
    
    @objc private func chipTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedChip = sender.view as? SportsChip else { return }
        
        chips.forEach { $0.isSelected = ($0 === selectedChip) }
        
        if let sports = getSports(from: selectedChip) {
            action?(sports)
        }
    }
    
    // MARK: - Private Methods
    
    private func getSports(from chip: SportsChip) -> Sports? {
        return Mirror(reflecting: chip).children.first(where: { $0.label == "sports" })?.value as? Sports
    }
}
