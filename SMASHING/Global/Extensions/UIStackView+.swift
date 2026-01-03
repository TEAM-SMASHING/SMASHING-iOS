//
//  UIStackView+.swift
//  SMASHING
//
//  Created by 이승준 on 12/29/25.
//

import UIKit

extension UIStackView {
    /// addArrangedSubview의 복수형 함수입니다
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}
