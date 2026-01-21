//
//  MatchingSearchView.swift
//  SMASHING
//
//  Created by JIN on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class MatchingSearchView: BaseUIView {

    // MARK: - UI Components

    let headerView = MatchingSearchHeader()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 11
        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .Background.canvas
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(
            MatchingSearchCell.self,
            forCellWithReuseIdentifier: MatchingSearchCell.reuseIdentifier
        )
        return collectionView
    }()

    // MARK: - Setup Methods

    override func setUI() {
        backgroundColor = UIColor(resource: .Background.canvas)
        addSubviews(headerView, collectionView)
    }

    override func setLayout() {
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
