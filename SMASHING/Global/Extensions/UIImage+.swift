//
//  UIImage+.swift
//  SMASHING
//
//  Created by 이승준 on 1/9/26.
//

import UIKit

extension UIImage {
    func tinted(with color: UIColor, isOpaque: Bool = false) -> UIImage? {
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            color.set()
            withRenderingMode(.alwaysTemplate).draw(at: .zero)
        }
    }
    
    static func defaultProfileImage(name: String) -> UIImage {
        switch ( name.unicodeScalars.reduce(0) { $0 + Int($1.value) } ) % 3 {
        case 0:
            return .profile01
        case 1:
            return .profile02
        case 2:
            return .profile03
        default:
            return UIImage()
        }
    }
}
