//
//  NotificationViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/12/26.
//

import UIKit

final class NotificationViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let mainView = NotificationView()
    
    private let dummyNotifications: [TempNotification] = [
        TempNotification(name: "와쿠와쿠", type: .matchingAccepted, tier: .gold1, isNew: true, time: "10:00 AM"),
        TempNotification(name: "시스템", type: .matchingRequested, tier: nil, isNew: false, time: "9:30 AM"),
        TempNotification(name: "매칭봇", type: .resultRejectedWinLoseReversed, tier: .silver3, isNew: true, time: "어제"),
        TempNotification(name: "사용자123", type: .reviewReceived, tier: .bronze2, isNew: false, time: "2일 전")
    ]
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        mainView.notificationCollection.dataSource = self
        mainView.notificationCollection.delegate = self
    }
}

// MARK: - CollectionView DataSource & Delegate
extension NotificationViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyNotifications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationCell.reuseIdentifier, for: indexPath) as? NotificationCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(notification: dummyNotifications[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100) // 100은 초기값일 뿐, automaticSize가 이를 덮어씁니다.
    }
}
