//
//  MyReviewsViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/14/26.
//

import UIKit

import SnapKit
import Then

struct TempReview {
    let nickname: String
    let date: String
    let content: String
}

final class MyReviewsViewController: BaseViewController, UICollectionViewDelegate {
    
    // MARK: - Properties
    
    private let myReviewsView = MyReviewsView().then {
        $0.configure([.fairPlay:6, .fastResponse: 10, .goodManner: 20, .onTime: 32])
    }
    
    // 임시 데이터 리스트
    private let mockReviews: [TempReview] = [
        TempReview(nickname: "닝우닝", date: "2일 전", content: "매너도 좋고, 너무 잘하세요!"),
        TempReview(nickname: "닝우닝닝이", date: "4일 전", content: "매너도 좋고, 너무 잘하세요!"),
        TempReview(nickname: "닝우닝닝이", date: "4일 전", content: "매너도 좋고, 너무 잘하세요!"),
        TempReview(nickname: "닝우닝닝이", date: "4일 전", content: "매너도 좋고, 너무 잘하세요!"),
        TempReview(nickname: "닝우", date: "5일 전", content: "매너도 좋고, 너무 잘하세요! 매너도 좋고, 너무 잘하세요! 매너도 좋고, 너무 잘하세요!"),
        TempReview(nickname: "친절한유저", date: "1주일 전", content: "약속 시간도 잘 지키시고 설명도 너무 친절하게 해주셔서 정말 기분 좋은 거래였습니다. 다음에 또 기회가 된다면 꼭 다시 뵙고 싶어요! 감사합니다 :)")
    ]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = myReviewsView
        setupDelegate()
    }
    
    private func setupDelegate() {
        myReviewsView.collectionView.delegate = self
        myReviewsView.collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource

extension MyReviewsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mockReviews.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ReviewCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? ReviewCollectionViewCell else { return UICollectionViewCell() }
        
        let data = mockReviews[indexPath.item]
        cell.configure(data)
        cell.contentView.snp.makeConstraints {
            $0.width.equalTo(collectionView.frame.width)
        }
        
        return cell
    }
}
