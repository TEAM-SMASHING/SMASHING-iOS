//
//  RapidReviewChipContainer.swift
//  SMASHING
//
//  Created by 홍준범 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class RapidReviewChipContainer: BaseUIView {
    
    private let horizontalSpacing: CGFloat = 8
    private let verticalSpacing: CGFloat = 8
    private var chips: [RapidReviewChip] = []
    
    func configure(reviews: [ReviewTag]) {
        chips.forEach { $0.removeFromSuperview() }
        chips.removeAll()
        
        reviews.forEach { review in
            let chip = RapidReviewChip(review: review)
            chips.append(chip)
            addSubviews(chip)
        }
        
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let containerWidth: CGFloat = bounds.width
        guard containerWidth > 0 else { return }
        
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var maxHeightInRow: CGFloat = 0
        
        chips.forEach { chip in
            let chipSize = chip.intrinsicContentSize
            
            if currentX + chipSize.width > containerWidth && currentX > 0 {
                currentX = 0
                currentY += maxHeightInRow + verticalSpacing
                maxHeightInRow = 0
            }
            
            chip.frame = CGRect(
                x: currentX,
                y: currentY,
                width: chipSize.width,
                height: chipSize.height
                )
            
            currentX += chipSize.width + horizontalSpacing
            maxHeightInRow = max(maxHeightInRow, chipSize.height)
        }
        
        let totalHeight = currentY + maxHeightInRow
        if totalHeight != bounds.height {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let containerWidth = bounds.width
        guard containerWidth > 0 else {
            return CGSize(width: UIView.noIntrinsicMetric, height: calculateHeight(for: superview?.bounds.width ?? 0))
        }
        
        return CGSize(width: containerWidth, height: calculateHeight(for: containerWidth))
    }
    
    private func calculateHeight(for width: CGFloat) -> CGFloat {
        guard width > 0 else { return 0 }
        
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var maxHeightInRow: CGFloat = 0
        
        chips.forEach { chip in
            let chipSize = chip.intrinsicContentSize
            
            if currentX + chipSize.width > width && currentX > 0 {
                currentX = 0
                currentY += maxHeightInRow + verticalSpacing
                maxHeightInRow = 0
            }
            
            currentX += chipSize.width + horizontalSpacing
            maxHeightInRow = max(maxHeightInRow, chipSize.height)
        }
        
        return currentY + maxHeightInRow
    }
    
    func getSelectedReviews() -> [ReviewTag] {
        return chips.filter { $0.isSelected }.map { $0.review }
    }
    
    func getChips() -> [RapidReviewChip] {
        return chips
    }
}
