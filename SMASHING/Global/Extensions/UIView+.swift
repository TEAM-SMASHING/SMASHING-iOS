//
//  UIView+.swift
//  SMASHING
//
//  Created by 이승준 on 12/29/25.
//

import UIKit

extension UIView {
    /// addSubview의 복수형 함수입니다
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
    
    /// cornerRadius를 설정하는 함수입니다
    func setCornerRadius(
        _ cornerRadius: CGFloat,
        maskedCorners: CACornerMask = [
            .layerMaxXMaxYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMinYCorner,
            .layerMinXMinYCorner
        ]
    ) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
    
}
