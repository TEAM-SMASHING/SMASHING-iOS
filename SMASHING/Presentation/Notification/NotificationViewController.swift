//
//  NotificationViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/12/26.
//

import UIKit

import SnapKit


import Combine

protocol NotificationViewModelProtocol: InputOutputProtocol where NotificationViewModel.Input == Input, NotificationViewModel.Output == Output {
    var notifications : [NotificationSummaryResponseDTO] {get}
}

final class NotificationViewModel: NotificationViewModelProtocol {
    
    enum Input {
        case viewDidLoad
        case reachedBottom
        case cellRead(index: Int)
    }
    
    struct Output {
        let dataFetched = PassthroughSubject<Void, Never>()
        let updateItem = PassthroughSubject<Int, Never>()
    }
    
    private let service: NotificationServiceProtocol
    let output = Output()
    var cancellables: Set<AnyCancellable> = []
    
    private(set) var notifications: [NotificationSummaryResponseDTO] = []
    private var nextCursor: String?
    private var snapshotAt: String?
    private var hasNextPage: Bool = true
    private var isFetching: Bool = false
    
    init(service: NotificationServiceProtocol) {
        self.service = service
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> Output {
        input
            .sink { [weak self] event in
                switch event {
                case .viewDidLoad:
                    self?.fetchNotifications(isInitial: true)
                case .reachedBottom:
                    self?.fetchNotifications(isInitial: false)
                case .cellRead(let index):
                    self?.markAsRead(at: index)
                }
            }
            .store(in: &cancellables)
        
        return output
    }
    
    private func fetchNotifications(isInitial: Bool) {
        guard !isFetching && (isInitial || hasNextPage) else { return }
        
        isFetching = true
        let cursor = isInitial ? nil : nextCursor
        
        service.fetchNotifications(size: 13, cursor: cursor, snapshotAt: snapshotAt)
            .sink { [weak self] completion in
                self?.isFetching = false
                if case .failure(let error) = completion {
                    print("알림 페치 에러: \(error)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                if isInitial {
                    self.notifications = response.data.results
                } else {
                    self.notifications.append(contentsOf: response.data.results)
                }
                
                self.nextCursor = response.data.nextCursor
                self.snapshotAt = response.data.snapshotAt
                self.hasNextPage = response.data.hasNext
                
                self.output.dataFetched.send(())
                self.isFetching = false
            }
            .store(in: &cancellables)
    }
    
    private func markAsRead(at index: Int) {
        let notification = notifications[index]
        guard !notification.isRead else { return }
        
        service.markAsRead(notificationId: notification.notificationId)
            .sink { _ in } receiveValue: { [weak self] _ in
                self?.notifications[index].isRead = true
                self?.output.updateItem.send(index)
            }
            .store(in: &cancellables)
    }
}

final class NotificationViewController: BaseViewController {
    
    private let mainView = NotificationView()
    private let viewModel: NotificationViewModel
    private let inputSubject = PassthroughSubject<NotificationViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: NotificationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bind()
        inputSubject.send(.viewDidLoad)
    }
    
    private func setupCollectionView() {
        mainView.notificationCollection.dataSource = self
        mainView.notificationCollection.delegate = self
        mainView.notificationCollection.register(NotificationCell.self, forCellWithReuseIdentifier: NotificationCell.reuseIdentifier)
    }
    
    private func bind() {
        let output = viewModel.transform(input: inputSubject.eraseToAnyPublisher())
        
        output.dataFetched
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.mainView.notificationCollection.reloadData()
            }
            .store(in: &cancellables)
        
        output.updateItem
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                let indexPath = IndexPath(item: index, section: 0)
                self?.mainView.notificationCollection.reloadItems(at: [indexPath])
            }
            .store(in: &cancellables)
        
        mainView.notificationCollection
            .reachedBottomPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                inputSubject.send(.reachedBottom)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Extensions DataSource & Delegate
extension NotificationViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.notifications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NotificationCell.reuseIdentifier,
            for: indexPath
        ) as? NotificationCell else { return UICollectionViewCell() }
        
        let data = viewModel.notifications[indexPath.item]
        cell.configure(notification: data)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputSubject.send(.cellRead(index: indexPath.item))
    }
}
