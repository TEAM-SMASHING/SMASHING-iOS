//
//  HomeDropDownView.swift
//  SMASHING
//
//  Created by JIN on 1/23/26.
//

import UIKit

import SnapKit
import Then

final class HomeDropDownView: BaseUIView {

    // MARK: - Properties
    
    var onRegionButtonTapped: (() -> Void)?
    var onSportsAndTierTapped: (() -> Void)?
    var onSportsCellTapped: ((Sports?) -> Void)?

    // MARK: - UI Components
    
    private let tierCard = TierCard(usesContainerView: false).then {
        $0.showsAddButton = false
        $0.backgroundColor = .Background.surface
    }

    private let winRateCard = WinRateCard(usesContainerView: false)
        .then {
            $0.backgroundColor = .Background.surface
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
        $0.layer.cornerRadius = 18
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
    
    private let regionStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
        
    // MARK: - Setup Methods

    override func setUI() {
        backgroundColor = .Background.surface
        setCornerRadius(16, maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        addSubviews(regionStackView, sportsAndTierStackView, bellImage, tierCard, winRateCard)
        
        regionStackView.addArrangedSubviews(pinImageView, regionLabel, chevronImageView)
        sportsAndTierStackView.addArrangedSubviews(sportsImage, tierLabel)
        tierCard.onSportsAction = { [weak self] sport in
            self?.onSportsCellTapped?(sport)
        }
        
        let regionTap = UITapGestureRecognizer(target: self, action: #selector(regionTapped))
        regionStackView.isUserInteractionEnabled = true
        regionStackView.addGestureRecognizer(regionTap)
        
        let sportsTap = UITapGestureRecognizer(target: self, action: #selector(sportsAndTierTapped))
        sportsAndTierStackView.isUserInteractionEnabled = true
        sportsAndTierStackView.addGestureRecognizer(sportsTap)
    }
    
    override func setLayout() {
        regionStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        pinImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        bellImage.snp.makeConstraints {
            $0.centerY.equalTo(regionStackView)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        sportsAndTierStackView.snp.makeConstraints {
            $0.centerY.equalTo(regionStackView)
            $0.trailing.equalTo(bellImage.snp.leading).offset(-12)
        }
        
        sportsImage.snp.makeConstraints {
            $0.size.equalTo(24)
        }

        tierCard.snp.makeConstraints {
            $0.top.equalTo(regionStackView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(264)
        }
        
        winRateCard.snp.makeConstraints {
            $0.top.equalTo(tierCard.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configure(profile: MyProfileListResponse) {
        tierCard.configure(profile: profile)
        winRateCard.configure(profile: profile)
    }
    
    // MARK: - Actions
    
    @objc private func regionTapped() {
        onRegionButtonTapped?()
    }
    
    @objc private func sportsAndTierTapped() {
        onSportsAndTierTapped?()
    }
}
