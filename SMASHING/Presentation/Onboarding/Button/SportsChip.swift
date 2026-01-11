//
//  SportsChip.swift
//  SMASHING
//
//  Created by 이승준 on 1/11/26.
//

import UIKit

import SnapKit
import Then

final class SportsChip: BaseUIView {
    
    // MARK: - Properties
    
    private let sport: Sports
    
    var isSelected: Bool = false {
        didSet { updateStyle() }
    }

    // MARK: - UI Components
    
    private let contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
        $0.isUserInteractionEnabled = false
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let label = UILabel().then {
        $0.font = .pretendard(.textMdM)
    }

    // MARK: - Init
    
    init(sport: Sports) {
        self.sport = sport
        super.init(frame: .zero)
        setupAttributes()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAttributes() {
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 1
        self.label.text = sport.rawValue
        updateStyle()
    }

    override func setUI() {
        addSubview(contentStackView)
        [imageView, label].forEach { contentStackView.addArrangedSubview($0) }
    }

    override func setLayout() {
        contentStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(24)
        }
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
    
    // MARK: - Private Methods

    private func updateStyle() {
        if isSelected {
            self.backgroundColor = .Background.selected
            self.layer.borderColor = UIColor.clear.cgColor
            self.imageView.image = sport.image.tinted(with: .Text.primaryReverse)
            self.label.textColor = .Text.primaryReverse
        } else {
            self.backgroundColor = .clear
            self.layer.borderColor = UIColor.Border.secondary.cgColor
            self.imageView.image = sport.image
            self.label.textColor = .Text.primary
        }
    }
}
