//
//  UILabel+.swift
//  SMASHING
//
//  Created by 이승준 on 1/5/26.
//

import UIKit

extension UILabel {

    func setPretendard(_ style: UIFont.PretendardStyle) {
        self.font = .pretendard(style)
        applyTypography(style)
    }

    private func applyTypography(_ style: UIFont.PretendardStyle) {
        guard let text = self.text else { return }

        let attributed = NSMutableAttributedString(string: text)

        let paragraph = NSMutableParagraphStyle()
        paragraph.minimumLineHeight = style.lineHeight
        paragraph.maximumLineHeight = style.lineHeight

        attributed.addAttributes([
            .font: UIFont.pretendard(style),
            .kern: style.letterSpacing,
            .paragraphStyle: paragraph
        ], range: NSRange(location: 0, length: attributed.length))

        self.attributedText = attributed
    }
}
