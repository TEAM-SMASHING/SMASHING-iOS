//
//  SentRequestViewController.swift
//  SMASHING
//
//  Created by JIN on 1/12/26.
//

import UIKit

import SnapKit
import Then

final class SentRequestViewController: BaseViewController {
    
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
        collectionview.register(SentRequestCell.self, forCellWithReuseIdentifier: SentRequestCell.reuseIdentifier)
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
        collectionview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension SentRequestViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.matches.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SentRequestCell.reuseIdentifier,
            for: indexPath
        ) as? SentRequestCell else {
            return UICollectionViewCell()
        }

        let match = self.matches[indexPath.row]
        cell.configure(
            nickname: match.nickname,
            gender: match.gender,
            tierCode: match.tierCode,
            wins: match.wins,
            losses: match.losses,
            reviews: match.reviewCount
        )
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SentRequestViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (collectionView.frame.width - 43) / 2
        let height: CGFloat = 203
        return CGSize(width: width, height: height)
    }
}

//MARK: - Data

extension SentRequestViewController {

    private func loadMockData() {
//        self.matches = [
//            TempRequesterInfo(
//                userId: "0USER000111225",
//                nickname: "나는다섯글자인간임ㅅㄱ",
//                gender: "MALE",
//                tierId: 4,
//                wins: 30,
//                losses: 15,
//                reviewCount: 8
//            ),
//            TempRequesterInfo(
//                userId: "0USER000111226",
//                nickname: "하은",
//                gender: "FEMALE",
//                tierId: 2,
//                wins: 15,
//                losses: 20,
//                reviewCount: 4
//            )
//        ]
        self.collectionview.reloadData()
    }

}
