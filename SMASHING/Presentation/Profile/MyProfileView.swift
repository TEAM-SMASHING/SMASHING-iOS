//
//  MyProfile.swift
//  SMASHING
//
//  Created by 이승준 on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class MyProfileView: BaseUIView {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let navigationBar = CustomNavigationBar(title: "프로필").then {
        $0.setLeftButtonHidden(true)
    }
    
    private let profileCard = ProfileCard()
    
    let tierCard = TierCard().then {
        $0.addTierDetailButton()
    }
    
    private let winRateCard = WinRateCard()
    
    let reviewCard = ReviewCard()
    
    // MARK: - Setup Methods
    
    override func setUI() {
        addSubview(navigationBar)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(profileCard, winRateCard, reviewCard, tierCard)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        profileCard.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(160)
        }
        
        tierCard.snp.makeConstraints {
            $0.top.equalTo(profileCard.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(330)
        }
        
        winRateCard.snp.makeConstraints {
            $0.top.equalTo(tierCard.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        reviewCard.snp.makeConstraints {
            $0.top.equalTo(winRateCard.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
