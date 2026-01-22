//
//  MatchingSectionHeader.swift
//  SMASHING
//
//  Created by 홍준범 on 1/12/26.
//

import UIKit

import SnapKit
import Then

final class MatchingSectionHeader: UICollectionReusableView, ReuseIdentifiable {
    
    var onMoreButtonTapped: (() -> Void)?
    
    private let titleLabel = UILabel().then {
        $0.setPretendard(.title2xlSb)
        $0.textColor = .Text.primary
    }
    
    private let subTitleLabel = UILabel().then {
        $0.setPretendard(.titleXlSb)
        $0.textColor = .Text.primary
    }
    
    private lazy var moreButton = UIButton().then {
        $0.setTitle("모두 보기", for: .normal)
        $0.titleLabel?.font = .pretendard(.textSmM)
        $0.setTitleColor(.Text.tertiary, for: .normal)
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
        addSubviews(titleLabel, subTitleLabel, moreButton)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.bottom.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    func configure(title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
    
    @objc
    private func moreButtonDidTap() {
        onMoreButtonTapped?()
    }
}
