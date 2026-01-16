//
//  SentRequestViewModel.swift
//  SMASHING
//
//  Created by Claude on 1/17/26.
//

import Foundation
import Combine

// MARK: - Protocol

protocol SentRequestViewModelProtocol: InputOutputProtocol
where Input == SentRequestViewModel.Input, Output == SentRequestViewModel.Output {}

// MARK: - ViewModel

final class SentRequestViewModel: SentRequestViewModelProtocol {

    // MARK: - Input/Output Types

    enum Input {
        case viewDidLoad
        case refresh
        case closeTapped(index: Int)
    }

    struct Output {
        let requestList: AnyPublisher<[TempRequesterInfo], Never>
        let isLoading: AnyPublisher<Bool, Never>
        let errorMessage: AnyPublisher<String, Never>
        let itemRemoved: AnyPublisher<Int, Never>
    }

    // MARK: - Private Subjects

    private let requestListSubject = CurrentValueSubject<[TempRequesterInfo], Never>([])
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorMessageSubject = PassthroughSubject<String, Never>()
    private let itemRemovedSubject = PassthroughSubject<Int, Never>()

    // MARK: - Public Subjects

    let requestCancelled = PassthroughSubject<Void, Never>()
    let refreshFromParent = PassthroughSubject<Void, Never>()

    // MARK: - Properties

    private var cancellables = Set<AnyCancellable>()
    private var lastRefreshTime: Date?

    // MARK: - Transform

    func transform(input: AnyPublisher<Input, Never>) -> Output {
        input
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .viewDidLoad:
                    self.fetchSentList()

                case .refresh:
                    self.handleRefresh()

                case .closeTapped(let index):
                    self.cancelRequest(at: index)
                }
            }
            .store(in: &cancellables)

        refreshFromParent
            .sink { [weak self] in
                self?.fetchSentList()
            }
            .store(in: &cancellables)

        return Output(
            requestList: requestListSubject.eraseToAnyPublisher(),
            isLoading: isLoadingSubject.eraseToAnyPublisher(),
            errorMessage: errorMessageSubject.eraseToAnyPublisher(),
            itemRemoved: itemRemovedSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Private Methods

    private func handleRefresh() {
        // Throttling: 0.5초 이내 재요청 방지
        let now = Date()
        if let lastTime = lastRefreshTime, now.timeIntervalSince(lastTime) < 0.5 {
            return
        }
        lastRefreshTime = now
        fetchSentList()
    }

    private func fetchSentList() {
        isLoadingSubject.send(true)

        // TODO: 실제 API 호출로 교체
        // NetworkProvider<MatchingAPI>.request(.getSentRequests, type: GenericResponse<[SentRequestInfo]>.self) { ... }

        // Mock 데이터 (API 연동 전)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }

            let mockData = [
                TempRequesterInfo(
                    userId: "0USER000111225",
                    nickname: "나는다섯글자인간임ㅅㄱ",
                    gender: "MALE",
                    tierId: 4,
                    wins: 30,
                    losses: 15,
                    reviewCount: 8
                ),
                TempRequesterInfo(
                    userId: "0USER000111226",
                    nickname: "하은",
                    gender: "FEMALE",
                    tierId: 2,
                    wins: 15,
                    losses: 20,
                    reviewCount: 4
                )
            ]

            self.requestListSubject.send(mockData)
            self.isLoadingSubject.send(false)
        }
    }

    private func cancelRequest(at index: Int) {
        guard index < requestListSubject.value.count else { return }

        let request = requestListSubject.value[index]
        isLoadingSubject.send(true)

        // TODO: 실제 API 호출로 교체
        // NetworkProvider<MatchingAPI>.request(.cancelRequest(requestId: request.userId), type: GenericResponse<EmptyResponse>.self) { ... }

        // Mock 취소 처리 (API 연동 전)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self else { return }

            var currentList = self.requestListSubject.value
            currentList.remove(at: index)
            self.requestListSubject.send(currentList)
            self.isLoadingSubject.send(false)
            self.itemRemovedSubject.send(index)

            // 탭 간 통신: 취소 완료 알림
            self.requestCancelled.send()
        }
    }
}

