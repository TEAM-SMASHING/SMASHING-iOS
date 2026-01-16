//
//  ReceiveRequestViewController.swift
//  SMASHING
//
//  Created by JIN on 1/12/26.
//

import UIKit

import SnapKit
import Then

final class ReceiveRequestViewController: BaseViewController {

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
        collectionview.register(ReceiveRequestCell.self, forCellWithReuseIdentifier: ReceiveRequestCell.reuseIdentifier)
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
}

extension ReceiveRequestViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return self.matches.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ReceiveRequestCell.reuseIdentifier,
            for: indexPath
        ) as? ReceiveRequestCell else {
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

extension ReceiveRequestViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (collectionView.frame.width - 43) / 2
        let height: CGFloat = 224
        return CGSize(width: width, height: height)
    }
}

//MARK: - Data

extension ReceiveRequestViewController {

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
