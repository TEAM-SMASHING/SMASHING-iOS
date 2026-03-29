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
    private let viewModel: NotificationViewModel
    private let inputSubject = PassthroughSubject<NotificationViewModel.Input, Never>()
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init

    init() {
        let service = NotificationService()
        self.viewModel = NotificationViewModel(service: service)
        super.init(nibName: nil, bundle: nil)
    }

    init(viewModel: any NotificationViewModelProtocol) {
        self.viewModel = viewModel as! NotificationViewModel
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
                guard let self else { return }
                let isEmpty = viewModel.notifications.isEmpty
                notificationListView.showEmptyView(isEmpty)
                notificationListView.collectionView.reloadData()
            }
            .store(in: &cancellables)

        output.showUnavailableToast
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                let toast = ToastMessage()
                let targetView = navigationController?.view ?? view
                targetView?.addSubview(toast)
                toast.configure(title: "열 수 없는 알림입니다.")
                toast.show()
            }
            .store(in: &cancellables)

        notificationListView.collectionView.reachedBottomPublisher
            .sink { [weak self] in
                self?.inputSubject.send(.reachedBottom)
            }
            .store(in: &cancellables)

        output.showSportChangeConfirmation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] info in
                guard let self else { return }
                let popup = ConfirmPopupViewController(
                    title: "\(info.sportDisplayName)로 종목을 변경하시겠어요?",
                    message: "종목은 내 프로필에서 재변경 가능합니다.",
                    cancelTitle: "아니오",
                    confirmTitle: "변경하기"
                )
                popup.onConfirmTapped = { [weak self] in
                    self?.inputSubject.send(.sportChangeConfirmed(
                        profileId: info.profileId,
                        notificationType: info.notificationType
                    ))
                }
                popup.onCancelTapped = { [weak self] in
                    self?.inputSubject.send(.sportChangeCancelled)
                }
                present(popup, animated: true)
            }
            .store(in: &cancellables)

        notificationListView.backAction = { [weak self] in
            self?.inputSubject.send(.backTapped)
        }

        output.navPop
            .receive(on: DispatchQueue.main)
            .sink { _ in
                NavigationManager.shared.pop()
            }
            .store(in: &cancellables)

        output.navConfirmedMatchManage
            .receive(on: DispatchQueue.main)
            .sink { _ in
                NavigationManager.shared.pop()
                NavigationManager.shared.handleNotificationAction(.navConfirmedMatchManage)
            }
            .store(in: &cancellables)

        output.navRequestedMatchManage
            .receive(on: DispatchQueue.main)
            .sink { _ in
                NavigationManager.shared.pop()
                NavigationManager.shared.handleNotificationAction(.navRequestedMatchManage)
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
