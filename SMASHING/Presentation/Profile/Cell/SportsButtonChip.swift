//
//  SatisfictionChip.swift
//  SMASHING
//
//  Created by 이승준 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class SportsButtonChip: UIButton {
    
    // MARK: - Properties
    
    private var sports: Sports?
    
    // MARK: - UI Components
    
    private let contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 10
        $0.isUserInteractionEnabled = false
    }
    
    private let plusImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .icPlus
    }

    private let label = UILabel().then {
        $0.font = .pretendard(.textSmR)
    }

    // MARK: - Setup Methods
    
    init(sports: Sports?, selected: Bool = false) {
        if sports != nil {
            contentStackView.addArrangedSubview(label)
            label.text = sports!.displayName
        } else {
            contentStackView.addArrangedSubview(plusImage)
        }
        super.init(frame: .zero)
        self.setSelected(selected)
        setUI()
        setLayout()
        setupAttributes()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAttributes() {
        self.layer.cornerRadius = 20
    }

    func setUI() {
        addSubview(contentStackView)
    }

    func setLayout() {
        contentStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(24)
        }
        
        plusImage.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
    
    func setSelected(_ isSelected: Bool) {
        backgroundColor = isSelected ? .Background.canvasReverse : .Background.overlay
        label.textColor = isSelected ? .Text.primaryReverse : .Text.secondary
    }
}
