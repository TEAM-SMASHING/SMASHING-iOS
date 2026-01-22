//
//  NotificationViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/12/26.
//

import Combine
import UIKit
import SnapKit

final class NotificationListViewController: BaseViewController {
    
    // MARK: - Properties
    private let notificationListView = NotificationView()
    private let viewModel: any NotificationViewModelProtocol
    private let inputSubject = PassthroughSubject<NotificationViewModel.Input, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    var backAction: (() -> Void)?

    // MARK: - Life Cycle
    init(viewModel: any NotificationViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = notificationListView
        setupDelegate()
        bind()
        inputSubject.send(.viewDidLoad)
    }
    
    private func setupDelegate() {
        notificationListView.collectionView.delegate = self
        notificationListView.collectionView.dataSource = self
    }
    
    private func bind() {
        let output = viewModel.transform(input: inputSubject.eraseToAnyPublisher())
        
        output.dataFetched
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.notificationListView.collectionView.reloadData()
            }
            .store(in: &cancellables)
            
        notificationListView.backAction = { [weak self] in
            self?.inputSubject.send(.backTapped)
        }
        
        output.navPop
            .sink { [weak self] in
                self?.backAction?()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDataSource
extension NotificationListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.notifications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NotificationCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? NotificationCollectionViewCell else { return UICollectionViewCell() }
        
        let data = viewModel.notifications[indexPath.item]
        cell.configure(data)
        
        cell.contentView.snp.remakeConstraints {
            $0.width.equalTo(collectionView.frame.width)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputSubject.send(.cellRead(index: indexPath.item))
    }
}
