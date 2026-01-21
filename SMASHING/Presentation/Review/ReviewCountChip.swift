//
//  ReviewCountChip.swift
//  SMASHING
//
//  Created by 이승준 on 1/16/26.
//

import UIKit

import SnapKit
import Then

final class ReviewCountChip: BaseUIView {
    
    // MARK: - Properties
    
    var reviewTag: ReviewTag?
    
    // MARK: - UI Components
    
    private let contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
        $0.isUserInteractionEnabled = false
    }
        
    private let titleLabel = UILabel().then {
        $0.textColor = .Text.secondary
        $0.font = .pretendard(.textSmR)
    }
    
    private let subLabel = UILabel().then {
        $0.textColor = .Text.secondary
        $0.font = .pretendard(.textSmSb)
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAttributes()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAttributes() {
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.backgroundColor = .Background.overlay
    }

    override func setUI() {
        addSubview(contentStackView)
        contentStackView.addArrangedSubviews(titleLabel, subLabel)
    }

    override func setLayout() {
        contentStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(24)
        }
    }
    
    func configure(with reviewTag: ReviewTag, count: Int) {
        self.reviewTag = reviewTag
        titleLabel.text = reviewTag.displayText + " "
        setNum(num: count)
    }
    
    func updateCount(_ count: Int) {
        subLabel.text = "\(count)"
    }
    
    func setNum(num: Int) {
        if num > 99 {
            subLabel.text = "99+"
        } else {
            subLabel.text = num.description
        }
    }
}
