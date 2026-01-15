//
//  UserProfileView.swift
//  SMASHING
//
//  Created by 이승준 on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class UserProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private let mainView = UserProfileView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        view = mainView
        mainView.reviewCard.reviewCollectionView.delegate = self
        mainView.reviewCard.reviewCollectionView.dataSource = self
    }
}

extension UserProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TempReview.mockReviews.count > 3 ? 3 : TempReview.mockReviews.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ReviewCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? ReviewCollectionViewCell else { return UICollectionViewCell() }
        
        let data = TempReview.mockReviews[indexPath.item]
        
        cell.configure(data)
        
        cell.contentView.snp.makeConstraints {
            $0.width.equalTo(collectionView.frame.width)
        }
        
        return cell
    }
}


final class UserProfileView: BaseUIView {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let navigationBar = CustomNavigationBar(title: "프로필").then {
        $0.setLeftButtonHidden(true)
    }
    
    private let profileCard = ProfileCard().then {
        $0.addChallengeButton()
    }
    
    let tierCard = TierCard()
    
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
            $0.height.equalTo(223)
        }
        
        tierCard.snp.makeConstraints {
            $0.top.equalTo(profileCard.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(264)
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

// MARK: - Preview

import SwiftUI

@available(iOS 18.0, *)
#Preview {
    UserProfileViewController()
}
