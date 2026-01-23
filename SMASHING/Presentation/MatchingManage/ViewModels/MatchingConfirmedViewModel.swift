//
//  MatchingConfirmedViewModel.swift
//  SMASHING
//
//  Created by JIN on 1/17/26.
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
        case closeTapped(index: Int)
        case matchingResultCreateButtonTapped(MatchingConfirmedGameDTO)
        case matchingResultConfirmButtonTapped(MatchingConfirmedGameDTO)
        
    }

    struct Output {
        let gameList: AnyPublisher<[MatchingConfirmedGameDTO], Never>
        let navToMatchResultCreate: AnyPublisher<MatchingConfirmedGameDTO, Never>
        let navToMatchResultConfirm: AnyPublisher<MatchingConfirmedGameDTO, Never>
        let isLoading: AnyPublisher<Bool, Never>
        let isLoadingMore: AnyPublisher<Bool, Never>
        let errorMessage: AnyPublisher<String, Never>
        let itemRemoved: AnyPublisher<Int, Never>
    }

    // MARK: - Private Subjects
    private let navToMatchResultCreateSubject = PassthroughSubject<MatchingConfirmedGameDTO, Never>()
    private let navToMatchResultConfirmSubject = PassthroughSubject<MatchingConfirmedGameDTO, Never>()
    private let gameListSubject = CurrentValueSubject<[MatchingConfirmedGameDTO], Never>([])
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let isLoadingMoreSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorMessageSubject = PassthroughSubject<String, Never>()
    private let itemRemovedSubject = PassthroughSubject<Int, Never>()

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
        sseBind()
    }

    // MARK: - Transform

    func transform(input: AnyPublisher<Input, Never>) -> Output {
        input
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .viewDidLoad:
                    self.fetchFirstPage()
                case .matchingResultCreateButtonTapped(let gameData):
                    navToMatchResultCreateSubject.send(gameData)
                case .matchingResultConfirmButtonTapped(let gameData):
                    navToMatchResultConfirmSubject.send(gameData)
                case .refresh:
                    self.handleRefresh()

                case .loadMore:
                    self.fetchNextPage()

                case .closeTapped(let index):
                    self.cancelGame(at: index)
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
            navToMatchResultCreate: navToMatchResultCreateSubject.eraseToAnyPublisher(),
            navToMatchResultConfirm: navToMatchResultConfirmSubject.eraseToAnyPublisher(),
            isLoading: isLoadingSubject.eraseToAnyPublisher(),
            isLoadingMore: isLoadingMoreSubject.eraseToAnyPublisher(),
            errorMessage: errorMessageSubject.eraseToAnyPublisher(),
            itemRemoved: itemRemovedSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Private Methods
    
    private func sseBind() {
        SSEService.shared.eventPublisher
            .receive(on: DispatchQueue.main)
            .sink { type in
                switch type {
                case .matchingAcceptNotificationCreated(_),
                        .gameResultRejectedNotificationCreated(_),
                        .gameResultSubmittedNotificationCreated(_),
                        .gameUpdated(_),
                        .matchingUpdated(_):
                    self.handleRefresh()
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }

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

        service.getConfirmedGameList(
            snapshotAt: snapshotAt,
            cursor: nextCursor,
            size: 20,
            order: "LATEST"
        )
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

    private func cancelGame(at index: Int) {
        guard index < gameListSubject.value.count else { return }

        let gameId = gameListSubject.value[index].gameID

        service.cancelGame(gameId: gameId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.handleCancelError(error)
                    }
                },
                receiveValue: { [weak self] _ in
                    guard let self else { return }
                    var currentList = self.gameListSubject.value
                    currentList.remove(at: index)
                    self.gameListSubject.send(currentList)
                    self.itemRemovedSubject.send(index)
                }
            )
            .store(in: &cancellables)
    }

    private func handleCancelError(_ error: NetworkError) {
        switch error {
        case .forbidden:
            errorMessageSubject.send("경기 참여자만 취소할 수 있습니다.")
        case .notFound:
            errorMessageSubject.send("게임을 찾을 수 없습니다.")
        case .badRequest:
            errorMessageSubject.send("결과가 확정된 경기는 취소할 수 없습니다.")
        default:
            errorMessageSubject.send("경기 취소에 실패했습니다.")
        }
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
