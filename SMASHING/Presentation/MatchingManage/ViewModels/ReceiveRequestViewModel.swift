//
//  ReceiveRequestViewModel.swift
//  SMASHING
//
//  Created by JIN on 1/18/26.
//

import Foundation
import Combine

// MARK: - Protocol

protocol ReceiveRequestViewModelProtocol: InputOutputProtocol
where Input == ReceiveRequestViewModel.Input, Output == ReceiveRequestViewModel.Output {}

// MARK: - ViewModel

final class ReceiveRequestViewModel: ReceiveRequestViewModelProtocol {

    // MARK: - Input/Output Types

    enum Input {
        case viewDidLoad
        case refresh
        case loadMore
        case skipTapped(index: Int)
        case acceptTapped(index: Int)
    }

    struct Output {
        let requestList: AnyPublisher<[ReceiveRequestResultDTO], Never>
        let isLoading: AnyPublisher<Bool, Never>
        let isLoadingMore: AnyPublisher<Bool, Never>
        let errorMessage: AnyPublisher<String, Never>
    }

    // MARK: - Private Subjects

    private let requestListSubject = CurrentValueSubject<[ReceiveRequestResultDTO], Never>([])
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let isLoadingMoreSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorMessageSubject = PassthroughSubject<String, Never>()

    // MARK: - Public Subjects

    let requestAccepted = PassthroughSubject<Void, Never>()
    let requestRejected = PassthroughSubject<Void, Never>()
    let refreshFromParent = PassthroughSubject<Void, Never>()

    // MARK: - Properties

    private let service: ReceiveRequestServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var lastRefreshTime: Date?

    // MARK: - Pagination State

    private var snapshotAt: String?
    private var nextCursor: String?
    private var hasNext: Bool = false

    // MARK: - Initialize

    init(service: ReceiveRequestServiceProtocol = ReceiveRequestService()) {
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
                    self.handleRefresh()

                case .loadMore:
                    self.fetchNextPage()

                case .skipTapped(let index):
                    self.skipRequest(at: index)

                case .acceptTapped(let index):
                    self.acceptRequest(at: index)
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
            errorMessage: errorMessageSubject.eraseToAnyPublisher()
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

        service.getReceivedRequestList(snapshotAt: nil, cursor: nil, size: 20)
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

        service.getReceivedRequestList(snapshotAt: snapshotAt, cursor: nextCursor, size: 20)
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
    
    private func acceptRequest(at index: Int) {
        guard index < requestListSubject.value.count else { return }

        let matchingId = requestListSubject.value[index].matchingID

        service.acceptRequest(matchingId: matchingId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.handleAcceptError(error)
                    }
                },
                receiveValue: { [weak self] _ in
                    guard let self else { return }
                    var currentList = self.requestListSubject.value
                    currentList.remove(at: index)
                    self.requestListSubject.send(currentList)
                    self.requestAccepted.send()
                }
            )
            .store(in: &cancellables)
    }
    
    private func skipRequest(at index: Int) {
        guard index < requestListSubject.value.count else { return }

        let matchingId = requestListSubject.value[index].matchingID
        
        service.rejectRequest(matchingId: matchingId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.handleAcceptError(error)
                    }
                },
                receiveValue: { [weak self] _ in
                    guard let self else { return }
                    var currentList = self.requestListSubject.value
                    currentList.remove(at: index)
                    self.requestListSubject.send(currentList)
                    self.requestRejected.send()
                }
            )
            .store(in: &cancellables)

    }

    private func handleAcceptError(_ error: NetworkError) {
        switch error {
        case .forbidden:
            errorMessageSubject.send("요청을 받은 사람만 수락할 수 있습니다.")
        case .notFound:
            errorMessageSubject.send("매칭 요청을 찾을 수 없습니다.")
        case .badRequest:
            errorMessageSubject.send("이미 처리된 요청입니다.")
        default:
            errorMessageSubject.send("요청 수락에 실패했습니다.")
        }
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
