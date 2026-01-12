//
//  CommonSectionHeader.swift
//  SMASHING
//
//  Created by 홍준범 on 1/12/26.
//

import UIKit

import SnapKit
import Then

final class CommonSectionHeader: UICollectionReusableView {
    static let identifier = "CommonSectionHeader"
    
    private let titleLabel = UILabel().then {
        $0.setPretendard(.subtitleLgSb)
        $0.textColor = .Text.primary
    }
    
    private let moreButton = UIButton().then {
        $0.setTitle("모두 보기", for: .normal)
        $0.titleLabel?.font = .pretendard(.textSmM)
        $0.setTitleColor(.Text.tertiary, for: .normal)
        $0.contentVerticalAlignment = .bottom
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubviews(titleLabel, moreButton)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
        }
    }
    
    func configure(title: String, showMoreButton: Bool = false) {
        titleLabel.text = title
        moreButton.isHidden = !showMoreButton
    }
}
