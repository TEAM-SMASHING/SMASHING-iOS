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
    
    private lazy var navigationBar = CustomNavigationBar(title: "알림") { [weak self] in
        guard let self else { return }
        backAction?()
    }
    
    let notificationCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.register(NotificationCell.self, forCellWithReuseIdentifier: NotificationCell.reuseIdentifier)
        
        return collection
    }()
    
    // MARK: - Setup Methods
    
    override func setUI() {
        addSubviews(navigationBar, notificationCollection)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        notificationCollection.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

import SwiftUI
@available(iOS 18.0, *)
#Preview {
    NotificationViewController()
}
