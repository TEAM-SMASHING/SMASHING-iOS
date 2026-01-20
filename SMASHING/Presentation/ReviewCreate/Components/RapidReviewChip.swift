//
//  rapidReviewChip.swift
//  SMASHING
//
//  Created by 홍준범 on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class RapidReviewChip: UILabel {
    
    var onSelectionChanged: (() -> Void)?
    
    let review: ReviewTag
    
    private var textInsets = UIEdgeInsets.zero
    
    var isSelected: Bool = false {
        didSet { updateStyle() }
    }
    
    init(review: ReviewTag) {
        self.review = review
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.text = review.displayText
        self.font = .pretendard(.textSmR)
        self.textAlignment = .center
        
        self.layer.cornerRadius = 18
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.textInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chipTapped))
        self.addGestureRecognizer(tapGesture)
        updateStyle()
    }
    
    private func updateStyle() {
        if isSelected {
            self.backgroundColor = .Background.selected
            self.layer.borderColor = UIColor.clear.cgColor
            self.textColor = .Text.primaryReverse
        } else {
            self.backgroundColor = .clear
            self.layer.borderColor = UIColor.Border.secondary.cgColor
            self.textColor = .Text.primary
        }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + textInsets.left + textInsets.right, height: size.height + textInsets.top + textInsets.bottom
        )
    }
    
    // MARK: Actions
    
    @objc
    private func chipTapped() {
        isSelected.toggle()
        onSelectionChanged?()
    }
}
