//
//  NotificationViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/12/26.
//

import UIKit

import SnapKit
import Then

final class NotificationView: BaseUIView {
    
    // MARK: - Properties
    
    var backAction: (() -> Void)?
    
    // MARK: - UI Components

    private lazy var navigationBar = CustomNavigationBar(title: "알림")

    private let emptyView = EmptyView().then {
        $0.configure(title: "아직 받은 알림이 없어요.", subtitle: "")
        $0.isHidden = true
    }

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(NotificationCollectionViewCell.self, forCellWithReuseIdentifier: NotificationCollectionViewCell.reuseIdentifier)
        return cv
    }()
    
    // MARK: - Setup Methods
    
    // MARK: - Setup Methods

    override func setUI() {
        addSubviews(navigationBar, collectionView, emptyView)

        navigationBar.setLeftButton {
            self.backAction?()
        }
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }

        emptyView.snp.makeConstraints {
            $0.center.equalTo(collectionView)
        }
    }

    // MARK: - Public Methods

    func showEmptyView(_ show: Bool) {
        emptyView.isHidden = !show
    }
}
