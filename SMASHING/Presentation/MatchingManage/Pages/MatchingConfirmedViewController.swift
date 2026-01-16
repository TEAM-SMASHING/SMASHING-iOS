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
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 11
        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)

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
        loadMockData()
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
            return "Iron I"
        case 2:
            return "Bronze I"
        case 3:
            return "Silver I"
        case 4:
            return "Gold I"
        case 5:
            return "Platinum I"
        case 6:
            return "Diamond I"
        case 7:
            return "Challenger"
        default:
            return "Unranked"
        }
    }

}

extension MatchingConfirmedViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return self.matches.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MatchingConfirmedCell.reuseIdentifier,
            for: indexPath
       ) as? MatchingConfirmedCell else {
           return UICollectionViewCell()
       }

        let match = self.matches[indexPath.row]
        cell.configure(
            nickname: match.nickname,
            gender: match.gender,
            tierId: match.tierId,
            wins: match.wins,
            losses: match.losses,
            reviews: match.reviewCount
        )
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MatchingConfirmedViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (collectionView.frame.width - 43) / 2
        let height: CGFloat = 222
        return CGSize(width: width, height: height)
    }
}

//MARK: - Data

extension MatchingConfirmedViewController {

    private func loadMockData() {
        self.matches = [
            TempRequesterInfo(
                userId: "0USER000111227",
                nickname: "도윤",
                gender: "MALE",
                tierId: 6,
                wins: 89,
                losses: 34,
                reviewCount: 25
            ),
            TempRequesterInfo(
                userId: "0USER000111228",
                nickname: "수아",
                gender: "FEMALE",
                tierId: 5,
                wins: 67,
                losses: 28,
                reviewCount: 18
            ),
            TempRequesterInfo(
                userId: "0USER000111229",
                nickname: "예준",
                gender: "MALE",
                tierId: 7,
                wins: 120,
                losses: 40,
                reviewCount: 35
            ),
            TempRequesterInfo(
                userId: "0USER000111230",
                nickname: "시우",
                gender: "MALE",
                tierId: 4,
                wins: 45,
                losses: 22,
                reviewCount: 12
            )
        ]
        self.collectionview.reloadData()
    }

}
