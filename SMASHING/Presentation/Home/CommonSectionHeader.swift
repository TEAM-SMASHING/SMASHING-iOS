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
    
    var onInfoButtonTapped: (() -> Void)?
    var onMoreButtonTapped: (() -> Void)?
    
    private let titleLabel = UILabel().then {
        $0.setPretendard(.subtitleLgSb)
        $0.textColor = .Text.primary
    }
    
    private lazy var infoButton = UIButton().then {
        $0.setImage(.icInfo, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(infoButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var moreButton = UIButton().then {
        $0.setTitle("모두 보기", for: .normal)
        $0.titleLabel?.font = .pretendard(.textSmM)
        $0.setTitleColor(.Text.tertiary, for: .normal)
        $0.contentVerticalAlignment = .bottom
        $0.addTarget(self, action: #selector(moreButtonDidTap), for: .touchUpInside)
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
        addSubviews(titleLabel, infoButton, moreButton)
    }
    
    @objc
    private func infoButtonDidTap() {
        onInfoButtonTapped?()
    }
    
    @objc
    private func moreButtonDidTap() {
        onMoreButtonTapped?()
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        infoButton.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(2)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        moreButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
        }
    }
    
    func configure(title: String, showInfoButton: Bool, showMoreButton: Bool = false) {
        titleLabel.text = title
        infoButton.isHidden = !showInfoButton
        moreButton.isHidden = !showMoreButton
    }
}
