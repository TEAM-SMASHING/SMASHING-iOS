//
//  UserProfileViewController 2.swift
//  SMASHING
//
//  Created by 이승준 on 1/16/26.
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
        
        mainView.configure(mode: .canAccept)
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
