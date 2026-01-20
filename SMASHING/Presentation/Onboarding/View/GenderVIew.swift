//
//  GenderVIew.swift
//  SMASHING
//
//  Created by 이승준 on 1/11/26.
//

import UIKit

import SnapKit
import Then

final class GenderView: BaseUIView {
    
    // MARK: - Properties
    
    var action: ((Gender) -> Void)?

    // MARK: - UI Components
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 11
    }
    
    private let maleButton = GenderButton(gender: .male)
    private let femaleButton = GenderButton(gender: .female)
    
    // MARK: - Setup Methods
    
    override func setUI() {
        addSubview(stackView)
        [maleButton, femaleButton].forEach { stackView.addArrangedSubview($0) }
        
        maleButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maleTapped)))
        femaleButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(femaleTapped)))
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(stackView.snp.width).multipliedBy(0.5).offset(-11)
        }
    }
    
    func configure(action: @escaping (Gender) -> Void) {
        self.action = action
    }
    
    // MARK: - Actions
    
    @objc private func maleTapped() {
        handleSelection(gender: .male)
    }
    
    @objc private func femaleTapped() {
        handleSelection(gender: .female)
    }
    
    func handleSelection(gender: Gender) {
        maleButton.isSelected = (gender == .male)
        femaleButton.isSelected = (gender == .female)
        action?(gender)
    }
}
