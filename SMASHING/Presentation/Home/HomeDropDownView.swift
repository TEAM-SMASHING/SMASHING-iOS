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
    
    var onRegionButtonTapped: ((_ regionFrame: CGRect) -> Void)?
    
    private var regionTopConstraint: Constraint?
    var onSportsAndTierTapped: (() -> Void)?
    var onSportsCellTapped: ((Sports?) -> Void)?
    var onBellTapped: (() -> Void)?
    var onAddSportsTapped: (() -> Void)?
    var onTierDetailTapped: (() -> Void)?
    var onMyPageTapped: (() -> Void)?
    
    // MARK: - UI Components
    
    private let tierCard = TierCard(usesContainerView: false).then {
        $0.showsAddButton = true
        $0.backgroundColor = .Background.surface
    }
    
    private let winRateCard = WinRateCard(usesContainerView: false).then {
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
        $0.image = .icBadminton.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .Icon.success
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
    
    private let myPageImage = UIImageView().then {
        $0.image = .icProfile
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
        addSubviews(regionStackView, sportsAndTierStackView, bellImage, myPageImage, tierCard, winRateCard)
        
        sportsAndTierStackView.addArrangedSubviews(sportsImage, tierLabel)
        
        regionStackView.addArrangedSubviews(pinImageView, regionLabel, chevronImageView)

        tierCard.onSportsAction = { [weak self] sport in
            self?.onSportsCellTapped?(sport)
        }
        tierCard.addAction = { [weak self] in
            self?.onAddSportsTapped?()
        }
        tierCard.addTierDetailButton()
        tierCard.tierDetailAction = { [weak self] in
            self?.onTierDetailTapped?()
        }
        
        let regionTap = UITapGestureRecognizer(target: self, action: #selector(regionTapped))
        regionStackView.isUserInteractionEnabled = true
        regionStackView.addGestureRecognizer(regionTap)
        
        let sportsTap = UITapGestureRecognizer(target: self, action: #selector(sportsAndTierTapped))
        sportsAndTierStackView.isUserInteractionEnabled = true
        sportsAndTierStackView.addGestureRecognizer(sportsTap)
        
        let bellTap = UITapGestureRecognizer(target: self, action: #selector(bellTapped))
        bellImage.isUserInteractionEnabled = true
        bellImage.addGestureRecognizer(bellTap)
        
        let myPageTap = UITapGestureRecognizer(target: self, action: #selector(myPageTapped))
        myPageImage.isUserInteractionEnabled = true
        myPageImage.addGestureRecognizer(myPageTap)
    }
    
    override func setLayout() {
        regionStackView.snp.makeConstraints {
            regionTopConstraint = $0.top.equalToSuperview().offset(0).constraint
            $0.leading.equalToSuperview().inset(16)
        }
        
        pinImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        myPageImage.snp.makeConstraints {
            $0.centerY.equalTo(regionStackView)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }

        bellImage.snp.makeConstraints {
            $0.centerY.equalTo(regionStackView)
            $0.trailing.equalTo(myPageImage.snp.leading).offset(-12)
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
            $0.height.equalTo(314)
        }

        winRateCard.snp.makeConstraints {
            $0.top.equalTo(tierCard.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(78)
        }
    }
    
    func updateRegionTopOffset(_ offset: CGFloat) {
        regionTopConstraint?.update(offset: offset)
    }
    
    func configure(profile: MyProfileListResponse, myRegion: String) {
        regionLabel.text = myRegion
        
        let sportCode = profile.activeProfile.sportCode.rawValue
        let tierCode = profile.activeProfile.tierCode
        
        sportsImage.image = Sports.image(from: sportCode)
        tierLabel.text = Tier.from(tierCode: tierCode)?.displayName ?? "—"
        
        // 기존 카드들
        tierCard.configure(profile: profile)
        winRateCard.configure(profile: profile)
    }
    
    // MARK: - Actions
    
    @objc
    private func regionTapped() {
        let frame = regionStackView.convert(regionStackView.bounds, to: nil)
        onRegionButtonTapped?(frame)
    }
    
    @objc
    private func sportsAndTierTapped() {
        onSportsAndTierTapped?()
    }
    
    @objc
    private func bellTapped() {
        onBellTapped?()
    }
    
    @objc
    private func myPageTapped() {
        onMyPageTapped?()
    }
}

