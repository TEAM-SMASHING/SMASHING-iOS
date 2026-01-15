//
//  RankingViewController.swift
//  SMASHING
//
//  Created by 홍준범 on 1/15/26.
//

import UIKit
import Combine

import SnapKit
import Then

extension RankingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rankingData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingCell", for: indexPath) as? RankingCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

extension RankingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 62)
    }
}

final class RankingViewController: BaseViewController {
    private let mainView = RankingView()
    
    
    private var rankingData: [Any] = []
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDummyData()
        view.backgroundColor = .Background.canvas
        
        mainView.registerCells()
        mainView.rankingCollectionView.delegate = self
        mainView.rankingCollectionView.dataSource = self
        
        updateEmptyState()
    }
    
    private func updateEmptyState() {
        mainView.updateEmptyState(isEmpty: rankingData.isEmpty)
    }
    
    private func setDummyData() {
        mainView.topThreePodium.configure(
            first: (
                nickname: "밤이달이밤이달이밤이",
                profileImage: nil,
                rankImage: .icRank1,
                tierImage: .bad,
                lp: 1430
            ),
            second: (
                nickname: "와구와구와구와구와구",
                profileImage: nil,
                rankImage: .icRank2,
                tierImage: .good,
                lp: 1298
            ),
            third: (
                nickname: "스매싱고수스매싱고수",
                profileImage: nil,
                rankImage: .icRank3,
                tierImage: .bad,
                lp: 1156
            )
        )
    }
}
