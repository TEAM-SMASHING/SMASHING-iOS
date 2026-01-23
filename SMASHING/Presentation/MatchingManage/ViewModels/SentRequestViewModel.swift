//
//  SentRequestViewModel.swift
//  SMASHING
//
//  Created by JIN on 1/17/26.
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
        case loadMore
        case closeTapped(index: Int)
    }

    struct Output {
        let requestList: AnyPublisher<[SentRequestResultDTO], Never>
        let isLoading: AnyPublisher<Bool, Never>
        let isLoadingMore: AnyPublisher<Bool, Never>
        let errorMessage: AnyPublisher<String, Never>
        let itemRemoved: AnyPublisher<Int, Never>
    }

    // MARK: - Private Subjects

    private let requestListSubject = CurrentValueSubject<[SentRequestResultDTO], Never>([])
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let isLoadingMoreSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorMessageSubject = PassthroughSubject<String, Never>()
    private let itemRemovedSubject = PassthroughSubject<Int, Never>()

    // MARK: - Public Subjects

    let requestCancelled = PassthroughSubject<Void, Never>()
    let refreshFromParent = PassthroughSubject<Void, Never>()

    // MARK: - Properties

    private let service: SentRequestServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var lastRefreshTime: Date?

    // MARK: - Pagination State

    private var snapshotAt: String?
    private var nextCursor: String?
    private var hasNext: Bool = false

    // MARK: - Initialize

    init(service: SentRequestServiceProtocol = SentRequestService()) {
        self.service = service
    }

    // MARK: - Transform

    func transform(input: AnyPublisher<Input, Never>) -> Output {
        input
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .viewDidLoad:
                    self.fetchFirstPage()

                case .refresh:
//                    self.handleRefresh()
                    self.fetchFirstPage()

                case .loadMore:
                    self.fetchNextPage()

                case .closeTapped(let index):
                    self.cancelRequest(at: index)
                }
            }
            .store(in: &cancellables)

        refreshFromParent
            .sink { [weak self] in
                self?.fetchFirstPage()
            }
            .store(in: &cancellables)

        return Output(
            requestList: requestListSubject.eraseToAnyPublisher(),
            isLoading: isLoadingSubject.eraseToAnyPublisher(),
            isLoadingMore: isLoadingMoreSubject.eraseToAnyPublisher(),
            errorMessage: errorMessageSubject.eraseToAnyPublisher(),
            itemRemoved: itemRemovedSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Private Methods

    private func handleRefresh() {
        let now = Date()
        if let lastTime = lastRefreshTime, now.timeIntervalSince(lastTime) < 0.5 {
            return
        }
        lastRefreshTime = now
        fetchFirstPage()
    }

    private func fetchFirstPage() {
        guard !isLoadingSubject.value else { return }

        isLoadingSubject.send(true)
        snapshotAt = nil
        nextCursor = nil
        hasNext = false

        service.getSentRequestList(snapshotAt: nil, cursor: nil, size: 20)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    self.isLoadingSubject.send(false)

                    if case .failure(let error) = completion {
                        self.handleError(error)
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }
                    self.snapshotAt = response.snapshotAt
                    self.nextCursor = response.nextCursor
                    self.hasNext = response.hasNext
                    self.requestListSubject.send(response.results)
                }
            )
            .store(in: &cancellables)
    }

    private func fetchNextPage() {
        guard !isLoadingMoreSubject.value,
              !isLoadingSubject.value,
              hasNext,
              let snapshotAt = snapshotAt else { return }

        isLoadingMoreSubject.send(true)

        service.getSentRequestList(snapshotAt: snapshotAt, cursor: nextCursor, size: 20)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    self.isLoadingMoreSubject.send(false)

                    if case .failure(let error) = completion {
                        self.handleError(error)
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }
                    self.nextCursor = response.nextCursor
                    self.hasNext = response.hasNext

                    var currentList = self.requestListSubject.value
                    currentList.append(contentsOf: response.results)
                    self.requestListSubject.send(currentList)
                }
            )
            .store(in: &cancellables)
    }

    private func cancelRequest(at index: Int) {
        guard index < requestListSubject.value.count else { return }

        let request = requestListSubject.value[index]
        isLoadingSubject.send(true)

        service.cancelSentRequest(matchingId: request.matchingID)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    self.isLoadingSubject.send(false)

                    if case .failure(let error) = completion {
                        self.handleError(error)
                    }
                },
                receiveValue: { [weak self] _ in
                    guard let self else { return }
                    var currentList = self.requestListSubject.value
                    currentList.remove(at: index)
                    self.requestListSubject.send(currentList)
                    self.itemRemovedSubject.send(index)
                    self.requestCancelled.send()
                }
            )
            .store(in: &cancellables)
    }

    private func handleError(_ error: NetworkError) {
        switch error {
        case .networkFail:
            errorMessageSubject.send("네트워크 연결을 확인해주세요.")
        case .unauthorized:
            errorMessageSubject.send("로그인이 필요합니다.")
        case .notFound:
            errorMessageSubject.send("요청을 찾을 수 없습니다.")
        default:
            errorMessageSubject.send("데이터를 불러오는데 실패했습니다.")
        }
    }
}

