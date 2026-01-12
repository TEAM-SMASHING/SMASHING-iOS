//
//  UIFont+.swift
//  SMASHING
//
//  Created by 이승준 on 1/5/26.
//

import UIKit

extension UIFont {
    
    enum PretendardStyle {
        case captionXsM, captionXsR, captionXxsM, captionXxsR
        case textSmSb, textSmM, textSmR, textMdSb, textMdM, textMdR
        case subtitleLgSb, subtitleLgM
        case titleXlSb, titleXlM
        case title2xlB, title2xlSb, title2xlM
        case headerHeroB, headerHeroSb
    }
    
    static func pretendard(_ style: PretendardStyle) -> UIFont {
        UIFont(name: style.fontName, size: style.size)
        ?? .systemFont(ofSize: style.size)
    }
}

extension UIFont.PretendardStyle {
    
    var size: CGFloat {
        switch self {
        case .headerHeroB, .headerHeroSb : return 28
        case .title2xlM, .title2xlSb, .title2xlB : return 24
        case .titleXlM, .titleXlSb : return 20
        case .subtitleLgM, .subtitleLgSb : return 18
        case .textMdM, .textMdR, .textMdSb : return 16
        case .textSmM, .textSmR, .textSmSb : return 14
        case .captionXsM, .captionXsR : return 12
        case .captionXxsM, .captionXxsR : return 10
        }
    }
    
    var fontName: String {
        switch self {
        case .title2xlM, .titleXlM, .subtitleLgM, .textMdM, .textSmM, .captionXsM, .captionXxsM : return "Pretendard-Medium"
        case .textMdR, .textSmR, .captionXsR, .captionXxsR : return "Pretendard-Regular"
        case .headerHeroSb, .title2xlSb, .titleXlSb, .subtitleLgSb, .textMdSb, .textSmSb : return "Pretendard-SemiBold"
        case .title2xlB, .headerHeroB : return "Pretendard-Bold"
        }
    }
    
    var letterSpacing: CGFloat {
        switch self {
        case .captionXsM, .captionXsR, .captionXxsM, .captionXxsR : return 0
        case .textMdM, .textMdR, .textSmM, .textSmR : return size * -0.01
        default : return size * -0.02
        }
    }
    
    var lineHeight: CGFloat {
        size * 1.5
    }
}
