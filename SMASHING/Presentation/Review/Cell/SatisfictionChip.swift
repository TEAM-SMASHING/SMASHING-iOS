//
//  SatisfictionChip.swift
//  SMASHING
//
//  Created by 이승준 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class SatisfictionChip: BaseUIView {
    
    // MARK: - Properties
    
    private var review: ReviewScore
    
    // MARK: - UI Components
    
    private let contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 10
        $0.isUserInteractionEnabled = false
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let label = UILabel().then {
        $0.font = .pretendard(.textSmR)
        $0.textColor = .Text.primary
    }
    
    // MARK: - Setup Methods
    
    init(review: ReviewScore, num: Int) {
        self.review = review
        if num > 99 {
            self.label.text = "99+"
        } else {
            self.label.text = "\(num)"
        }
        super.init(frame: .zero)
        backgroundColor = .Background.overlay
        setupAttributes()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAttributes() {
        self.layer.cornerRadius = 20
        self.imageView.image = review.imageSmall
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
}
