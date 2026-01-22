//
//  NotificationViewModel.swift
//  SMASHING
//
//  Created by 이승준 on 1/22/26.
//

import Combine

protocol NotificationViewModelProtocol: InputOutputProtocol where NotificationViewModel.Input == Input, NotificationViewModel.Output == Output {
    var notifications : [NotificationSummaryResponseDTO] {get}
}

final class NotificationViewModel: NotificationViewModelProtocol {
    
    enum Input {
        case viewDidLoad
        case reachedBottom
        case cellRead(index: Int)
        case backTapped
    }
    
    struct Output {
        let dataFetched = PassthroughSubject<Void, Never>()
        let updateItem = PassthroughSubject<Int, Never>()
        let navReview = PassthroughSubject<Void, Never>()
        let navRequestedMatchManage = PassthroughSubject<Void, Never>()
        let navConfirmedMatchManage = PassthroughSubject<Void, Never>()
        let navPop = PassthroughSubject<Void, Never>()
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
                guard let self else { return }
                switch event {
                case .viewDidLoad:
                    fetchNotifications(isInitial: true)
                case .reachedBottom:
                    fetchNotifications(isInitial: false)
                case .cellRead(let index):
                    markAsRead(at: index)
                    switch notifications[index].type {
                    case .reviewReceived:
                        output.navReview.send()
                    case .matchingRequested:
                        output.navRequestedMatchManage.send()
                    default:
                        output.navConfirmedMatchManage.send()
                    }
                case .backTapped:
                    output.navPop.send()
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
