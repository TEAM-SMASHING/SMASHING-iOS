//
//  NotificationViewModel.swift
//  SMASHING
//
//  Created by 이승준 on 1/22/26.
//

import Combine
import Foundation

protocol NotificationViewModelProtocol: InputOutputProtocol where NotificationViewModel.Input == Input, NotificationViewModel.Output == Output {
    var notifications : [NotificationSummaryResponseDTO] {get}
}

final class NotificationViewModel: NotificationViewModelProtocol {
    
    enum Input {
        case viewDidLoad
        case reachedBottom
        case cellRead(index: Int)
        case backTapped
        case sportChangeConfirmed(profileId: String, notificationType: NotificationType)
        case sportChangeCancelled
    }

    struct SportChangeInfo {
        let sportDisplayName: String
        let profileId: String
        let notificationType: NotificationType
    }

    struct Output {
        let dataFetched = PassthroughSubject<Void, Never>()
        let updateItem = PassthroughSubject<Int, Never>()
        let navReview = PassthroughSubject<Void, Never>()
        let navRequestedMatchManage = PassthroughSubject<Void, Never>()
        let navConfirmedMatchManage = PassthroughSubject<Void, Never>()
        let navPop = PassthroughSubject<Void, Never>()
        let showUnavailableToast = PassthroughSubject<Void, Never>()
        let showSportChangeConfirmation = PassthroughSubject<SportChangeInfo, Never>()
    }

    private let service: NotificationServiceProtocol
    private let profileService: UserProfileServiceType
    let output = Output()
    var cancellables: Set<AnyCancellable> = []

    private(set) var notifications: [NotificationSummaryResponseDTO] = []
    private var nextCursor: String?
    private var snapshotAt: String?
    private var hasNextPage: Bool = true
    private var isFetching: Bool = false
    private var isNavigating: Bool = false  // 중복 탭 방지

    init(service: NotificationServiceProtocol, profileService: UserProfileServiceType = UserProfileService()) {
        self.service = service
        self.profileService = profileService
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
                    handleNotificationTap(at: index)
                case .backTapped:
                    output.navPop.send()
                case .sportChangeConfirmed(let profileId, let notificationType):
                    performSportChange(profileId: profileId, notificationType: notificationType)
                case .sportChangeCancelled:
                    isNavigating = false
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
    
    private func handleNotificationTap(at index: Int) {
        guard !isNavigating else { return }
        isNavigating = true

        let notificationId = notifications[index].notificationId
        let notificationType = notifications[index].type

        service.checkSportMatch(notificationId: notificationId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                if case .failure = completion {
                    // 삭제·취소·탈퇴·차단 등으로 열 수 없는 알림
                    output.showUnavailableToast.send()
                    isNavigating = false
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                let matchData = response.data

                if matchData.isMatch {
                    // 종목 일치 → 바로 이동
                    navigate(for: notificationType)
                    isNavigating = false
                } else {
                    // 종목 불일치 → 확인 팝업 표시 (isNavigating은 팝업 응답 후 해제)
                    let sportName = Sports(rawValue: matchData.notificationSportCode)?.displayName
                                    ?? matchData.notificationSportCode
                    output.showSportChangeConfirmation.send(SportChangeInfo(
                        sportDisplayName: sportName,
                        profileId: matchData.receiverUserProfileId,
                        notificationType: notificationType
                    ))
                }
            }
            .store(in: &cancellables)
    }

    private func performSportChange(profileId: String, notificationType: NotificationType) {
        profileService.updateActiveProfile(profileId: profileId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                if case .failure = completion {
                    output.showUnavailableToast.send()
                }
                isNavigating = false
            } receiveValue: { [weak self] _ in
                guard let self else { return }
                // 전환된 프로필 ID를 Keychain에 저장
                _ = KeychainService.add(key: Environment.activeProfileKey, value: profileId)
                navigate(for: notificationType)
                isNavigating = false
            }
            .store(in: &cancellables)
    }

    private func navigate(for type: NotificationType) {
        switch type {
        case .reviewReceived:
            output.navReview.send()
        case .matchingRequested:
            output.navRequestedMatchManage.send()
        default:
            output.navConfirmedMatchManage.send()
        }
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
