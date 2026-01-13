//
//  MatchingConfirmedViewController.swift
//  SMASHING
//
//  Created by JIN on 1/12/26.
//

import UIKit

import SnapKit
import Then

final class MatchingConfirmedViewController: BaseViewController {
    
    //MARK: -UIComponents
    
    private lazy var collectionview : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.backgroundColor = .black
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.showsVerticalScrollIndicator = false
        collectionview.register(MatchingConfirmedCell.self, forCellWithReuseIdentifier: MatchingConfirmedCell.reuseIdentifier)
        return collectionview
    }()
    
    //MARK: - Properties
    
    private var matches: [TempRequesterInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Setup Methods
    
    override func setUI() {
        view.backgroundColor = UIColor(resource: .Background.canvas)
        view.addSubviews(collectionview)
    }
    
    override func setLayout() {
        super.setLayout()
        collectionview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    //MARK: - private Methods
    
    private func getTierName(tier: Int) -> String {
        switch tier {
        case 1:
            return "Bronze I"
        case 2:
            return "Silver I"
        case 3:
            return "Gold I"
        case 4:
            return "Platinum I"
        case 5:
            return "Diamond I"
        case 6:
            return "Master"
        case 7:
            return "Challenger"
        default:
            return "Unranked"
        }
    }
    
}

extension MatchingConfirmedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MatchingConfirmedCell.reuseIdentifier,
            for: indexPath) as! MatchingConfirmedCell
        
        let match = self.matches[indexPath.row]
        let tierName = self.getTierName(tier: match.tierId)
        cell.configure(nickname: match.nickname, tier: tierName, wins: match.wins, losses: match.losses, reviews: match.reviewCount)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MatchingConfirmedViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 48) / 2
        let height: CGFloat = 320
        return CGSize(width: width, height: height)
    }
}

//MARK: - Data

extension MatchingConfirmedViewController {
    
    private func loadMockData() {
        self.matches = [
            TempRequesterInfo(
                userId: "0USER000111222",
                nickname: "윤서",
                gender: "FEMALE",
                tierId: 3,
                wins: 12,
                losses: 7,
                reviewCount: 5
            ),
            TempRequesterInfo(
                userId: "0USER000111223",
                nickname: "민준",
                gender: "MALE",
                tierId: 5,
                wins: 45,
                losses: 12,
                reviewCount: 15
            ),
            TempRequesterInfo(
                userId: "0USER000111224",
                nickname: "지우",
                gender: "FEMALE",
                tierId: 2,
                wins: 8,
                losses: 10,
                reviewCount: 3
            )
        ]
        self.collectionview.reloadData()
    }

}
