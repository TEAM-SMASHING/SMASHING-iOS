//
//  TierButton.swift
//  SMASHING
//
//  Created by 이승준 on 1/11/26.
//

import UIKit

import SnapKit
import Then

final class ExperienceRangeButton: BaseUIView {
    
    // MARK: - Properties
    
    private let experienceRange: ExperienceRange
    
    var isSelected: Bool = false {
        didSet { updateStyle() }
    }

    // MARK: - UI Components
    
    private let contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 12
        $0.isUserInteractionEnabled = false
    }
    
    private let radioButtonImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let label = UILabel().then {
        $0.font = .pretendard(.textMdM)
        $0.textColor = .Text.primary
    }

    // MARK: - Init
    
    init(tier: ExperienceRange) {
        self.experienceRange = tier
        label.text = tier.displayText
        super.init(frame: .zero)
        backgroundColor = .clear
        setupAttributes()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAttributes() {
        // self.label.text = title
        updateStyle()
    }

    override func setUI() {
        addSubview(contentStackView)
        [radioButtonImageView, label].forEach { contentStackView.addArrangedSubview($0) }
    }

    override func setLayout() {
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
        
        radioButtonImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
    
    // MARK: - Private Methods

    private func updateStyle() {
        if isSelected {
            radioButtonImageView.image = .icRadioFill
        } else {
            radioButtonImageView.image = .icRadioEmpty
        }
    }
    
    // MARK: - Public Methods
    
    func getExperienceRange() -> ExperienceRange {
        return self.experienceRange
    }
}
