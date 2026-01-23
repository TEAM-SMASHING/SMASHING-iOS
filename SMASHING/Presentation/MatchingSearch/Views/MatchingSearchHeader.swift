//
//  MatchingSearchHeader.swift
//  SMASHING
//
//  Created by JIN on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class MatchingSearchHeader: BaseUIView {
    
    // MARK: - UI Components
    
    private let locationStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    
    private let locationImageView = UIImageView().then {
        $0.image = .icLocation
        $0.contentMode = .scaleAspectFit
    }
    
    private let locationLabel = UILabel().then {
        $0.text = "양천구"
        $0.textColor = .Text.primary
        $0.font = .pretendard(.subtitleLgSb)
        $0.textAlignment = .center
    }
    
    private let chevronImageView = UIImageView().then {
        $0.image = .icArrowDown
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var searchButton = UIButton().then {
        $0.setImage(UIImage(resource: .icSearhLg), for: .normal)
        $0.addTarget(self,action: #selector(searchButtonDidTap),for: .touchUpInside)
    }
    
    private let tierFilterContainer = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 17
    }
    
    private let tierfilterStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }
    
    private let tierFilterLabel = UILabel().then {
        $0.text = "티어"
        $0.textColor = .Text.primary
        $0.font = .pretendard(.textSmM)
    }
    
    private let tierFilterIconView = UIImageView().then {
        $0.image = UIImage(resource: .icArrowDown)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .Text.primary
    }
    
    private let tierFilterCloseIconView = UIImageView().then {
        $0.image = UIImage(resource: .icCloseSm).withRenderingMode(.alwaysTemplate)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .Text.primaryReverse
        $0.isHidden = true
    }
    
    private let genderFilterContainer = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 17
    }
    
    private let genderFilterStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }
    
    private let genderFilterLabel = UILabel().then {
        $0.text = "성별"
        $0.textColor = .Text.primary
        $0.font = .pretendard(.textSmM)
    }
    
    private let genderFilterIconView = UIImageView().then {
        $0.image = UIImage(resource: .icArrowDown)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .Text.primary
    }
    
    private let genderFilterCloseIconView = UIImageView().then {
        $0.image = UIImage(resource: .icCloseSm).withRenderingMode(.alwaysTemplate)
        $0.tintColor = .Text.primaryReverse
        $0.isHidden = true
    }
    
    private let filterStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .leading
    }
    
    // MARK: - Properties
    
    var onRegionTapped: (() -> Void)?
    var onSearchTapped: (() -> Void)?
    var onTierFilterTapped: (() -> Void)?
    var onGenderFilterTapped: (() -> Void)?
    var onTierFilterReset: (() -> Void)?
    var onGenderFilterReset: (() -> Void)?
    
    // MARK: - Public Methods
    
    func updateTierFilterButton(with tierName: String) {
        tierFilterLabel.text = tierName
        tierFilterContainer.backgroundColor = .Background.selected
        tierFilterLabel.textColor = .Text.primaryReverse
        tierFilterIconView.isHidden = true
        tierFilterCloseIconView.isHidden = false
    }
    
    func updateGenderFilterButton(with genderName: String) {
        genderFilterLabel.text = genderName
        genderFilterContainer.backgroundColor = .Background.selected
        genderFilterLabel.textColor = .Text.primaryReverse
        genderFilterIconView.isHidden = true
        genderFilterCloseIconView.isHidden = false
    }
    
    func resetTierFilterButton() {
        tierFilterLabel.text = "티어"
        tierFilterContainer.backgroundColor = .Background.surface
        tierFilterLabel.textColor = .Text.primary
        tierFilterCloseIconView.isHidden = true
        tierFilterIconView.isHidden = false
    }
    
    func resetGenderFilterButton() {
        genderFilterLabel.text = "성별"
        genderFilterContainer.backgroundColor = .Background.surface
        genderFilterLabel.textColor = .Text.primary
        genderFilterCloseIconView.isHidden = true
        genderFilterIconView.isHidden = false
    }
    
    func configure(region: String) {
        locationLabel.text = region
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        backgroundColor = .Background.canvas
        
        locationStackView.addArrangedSubviews(locationImageView, locationLabel, chevronImageView)
        
        addSubviews(
            locationStackView,
            searchButton,
            filterStackView
        )
                
        tierfilterStackView.addArrangedSubviews(
            tierFilterLabel,
            tierFilterIconView,
            tierFilterCloseIconView
        )
        tierFilterContainer.addSubview(tierfilterStackView)
        
        genderFilterStackView.addArrangedSubviews(
            genderFilterLabel,
            genderFilterIconView,
            genderFilterCloseIconView
        )
        genderFilterContainer.addSubview(genderFilterStackView)
        
        filterStackView.addArrangedSubviews(tierFilterContainer, genderFilterContainer)
    }
    
    override func setLayout() {
        locationStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(12)
            $0.leading.equalToSuperview().offset(16)
        }
        
        locationImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalTo(locationStackView)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(24)
        }
        
        filterStackView.snp.makeConstraints {
            $0.top.equalTo(locationStackView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        tierFilterContainer.snp.makeConstraints {
            $0.height.equalTo(34)
        }
        
        tierfilterStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 10))
        }
        
        tierFilterIconView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        tierFilterCloseIconView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        genderFilterContainer.snp.makeConstraints {
            $0.height.equalTo(34)
        }
        
        genderFilterStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 10))
        }
        
        genderFilterIconView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        genderFilterCloseIconView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
    
    override func setGesture() {
        
        let tierTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(tierFilterButtonDidTap)
        )
        tierFilterContainer.addGestureRecognizer(tierTapGesture)
        
        let tierCloseTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(tierFilterCloseButtonDidTap)
        )
        tierFilterCloseIconView.addGestureRecognizer(tierCloseTapGesture)
        tierFilterCloseIconView.isUserInteractionEnabled = true
        
        let genderTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(genderFilterButtonDidTap)
        )
        genderFilterContainer.addGestureRecognizer(genderTapGesture)
        
        let genderCloseTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(genderFilterCloseButtonDidTap)
        )
        genderFilterCloseIconView.addGestureRecognizer(genderCloseTapGesture)
        genderFilterCloseIconView.isUserInteractionEnabled = true
        
        let regionTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(regionTapped)
        )
        locationStackView.addGestureRecognizer(regionTapGesture)
        locationStackView.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    
    @objc private func searchButtonDidTap() {
        onSearchTapped?()
    }
    
    @objc private func tierFilterButtonDidTap() {
        onTierFilterTapped?()
    }
    
    @objc private func tierFilterCloseButtonDidTap() {
        resetTierFilterButton()
        onTierFilterReset?()
        
    }
    
    @objc private func genderFilterButtonDidTap() {
        onGenderFilterTapped?()
    }
    
    @objc private func genderFilterCloseButtonDidTap() {
        resetGenderFilterButton()
        onGenderFilterReset?()
    }
    
    @objc private func regionTapped() {
        onRegionTapped?()
    }
}


