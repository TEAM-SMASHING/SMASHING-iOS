//
//  MatchingConfirmedViewModel.swift
//  SMASHING
//
//  Created by Claude on 1/17/26.
//

import Foundation
import Combine

// MARK: - Protocol

protocol MatchingConfirmedViewModelProtocol: InputOutputProtocol
where Input == MatchingConfirmedViewModel.Input, Output == MatchingConfirmedViewModel.Output {}

// MARK: - ViewModel

final class MatchingConfirmedViewModel: MatchingConfirmedViewModelProtocol {

    // MARK: - Input/Output Types

    enum Input {
        case viewDidLoad
        case refresh
        case loadMore
    }

    struct Output {
        let gameList: AnyPublisher<[MatchingConfirmedGameDTO], Never>
        let isLoading: AnyPublisher<Bool, Never>
        let isLoadingMore: AnyPublisher<Bool, Never>
        let errorMessage: AnyPublisher<String, Never>
    }

    // MARK: - Private Subjects

    private let gameListSubject = CurrentValueSubject<[MatchingConfirmedGameDTO], Never>([])
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let isLoadingMoreSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorMessageSubject = PassthroughSubject<String, Never>()

    // MARK: - Public Subjects

    let refreshFromParent = PassthroughSubject<Void, Never>()

    // MARK: - Properties

    private let service: MatchingConfirmedServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var lastRefreshTime: Date?

    // MARK: - Pagination State

    private var snapshotAt: String?
    private var nextCursor: String?
    private var hasNext: Bool = false

    // MARK: - Initialize

    init(service: MatchingConfirmedServiceProtocol = MatchingConfirmedService()) {
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
                }
            }
            .store(in: &cancellables)

        refreshFromParent
            .sink { [weak self] in
                self?.fetchFirstPage()
            }
            .store(in: &cancellables)

        return Output(
            gameList: gameListSubject.eraseToAnyPublisher(),
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

        service.getConfirmedGameList(snapshotAt: nil, cursor: nil, size: 20, order: "LATEST")
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
                    self.gameListSubject.send(response.results)
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

        service.getConfirmedGameList(snapshotAt: snapshotAt, cursor: nextCursor, size: 20, order: "LATEST")
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

                    var currentList = self.gameListSubject.value
                    currentList.append(contentsOf: response.results)
                    self.gameListSubject.send(currentList)
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
            errorMessageSubject.send("게임을 찾을 수 없습니다.")
        default:
            errorMessageSubject.send("데이터를 불러오는데 실패했습니다.")
        }
    }
}
