//
//  HomeNavigationBar.swift
//  SMASHING
//
//  Created by 홍준범 on 1/14/26.
//

import UIKit

import Then
import SnapKit

final class HomeNavigationBarCell: BaseUICollectionViewCell, ReuseIdentifiable {
    var onRegionButtonTapped: (() -> Void)?
    
    private let regionStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    
    private let pinImageView = UIImageView().then {
        $0.image = .icLocation
        $0.contentMode = .scaleAspectFit
    }
    
    private let regionLabel = UILabel().then {
        $0.text = "양천구"
        $0.textColor = .Text.primary
        $0.font = .pretendard(.subtitleLgSb)
        $0.textAlignment = .center
    }
    
    private let chevronImageView = UIImageView().then {
        $0.image = .icArrowDown
        $0.contentMode = .scaleAspectFit
    }
    
    private let sportsAndTierStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.Border.secondary.cgColor
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
    }
    
    private let sportsImage = UIImageView().then {
        $0.image = .icBadminton
        $0.contentMode = .scaleAspectFit
    }
    
    private let tierLabel = UILabel().then {
        $0.text = "Sliver III"
        $0.font = .pretendard(.textSmM)
        $0.textColor = .Icon.success
    }
    
    private let bellImage = UIImageView().then {
        $0.image = .icBell
        $0.contentMode = .scaleAspectFit
    }
    
    override func setUI() {
        regionStackView.addArrangedSubviews(pinImageView, regionLabel, chevronImageView)
        
        sportsAndTierStackView.addArrangedSubviews(sportsImage, tierLabel)
        
        addSubviews(regionStackView, sportsAndTierStackView, bellImage)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(regionTapped))
        regionStackView.isUserInteractionEnabled = true
        regionStackView.addGestureRecognizer(tap)
    }
    
    override func setLayout() {
        regionStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        pinImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        bellImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        sportsAndTierStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(bellImage.snp.leading).offset(-12)
        }
        
        sportsImage.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
    
    func configure(region: String) {
        regionLabel.text = region
    }
    
    @objc
    private func regionTapped() {
        onRegionButtonTapped?()
    }
}
