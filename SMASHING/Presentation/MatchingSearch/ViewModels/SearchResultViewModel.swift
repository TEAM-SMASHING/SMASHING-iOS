//
//  SearchResultViewModel.swift
//  SMASHING
//
//  Created by JIN on 1/21/26.
//

import Foundation
import Combine

// MARK: - Protocol

protocol SearchResultViewModelProtocol {
    var searchResults: [UserSummary] { get }
    func transform(input: AnyPublisher<SearchResultViewModel.Input, Never>) -> SearchResultViewModel.Output
}

// MARK: - ViewModel

final class SearchResultViewModel: SearchResultViewModelProtocol {

    // MARK: - Input/Output

    enum Input {
        case searchNickname(String)
        case userSelected(String)
        case backTapped
    }

    struct Output {
        let dataFetched: AnyPublisher<Void, Never>
        let isLoading: AnyPublisher<Bool, Never>
        let errorMessage: AnyPublisher<String, Never>
    }

    struct NavigationEvent {
        let backTapped = PassthroughSubject<Void, Never>()
        let userSelected = PassthroughSubject<String, Never>()
    }

    // MARK: - Properties

    private(set) var searchResults: [UserSummary] = []
    let navigationEvent = NavigationEvent()

    private let userSearchService: UserSearchServiceType
    private var cancellables = Set<AnyCancellable>()
    private var isFetching = false

    private let dataFetchedSubject = PassthroughSubject<Void, Never>()
    private let isLoadingSubject = PassthroughSubject<Bool, Never>()
    private let errorMessageSubject = PassthroughSubject<String, Never>()

    // MARK: - Initialize

    init(userSearchService: UserSearchServiceType = UserSearchService()) {
        self.userSearchService = userSearchService
    }

    // MARK: - Transform

    func transform(input: AnyPublisher<Input, Never>) -> Output {
        input
            .sink { [weak self] event in
                switch event {
                case .searchNickname(let query):
                    self?.handleSearch(query)
                case .userSelected(let userId):
                    self?.navigationEvent.userSelected.send(userId)
                case .backTapped:
                    self?.navigationEvent.backTapped.send()
                }
            }
            .store(in: &cancellables)

        return Output(
            dataFetched: dataFetchedSubject.eraseToAnyPublisher(),
            isLoading: isLoadingSubject.eraseToAnyPublisher(),
            errorMessage: errorMessageSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Private Methods

    private func handleSearch(_ query: String) {
        guard !isFetching else { return }

        guard !query.isEmpty else {
            self.searchResults = []
            self.dataFetchedSubject.send()
            return
        }

        isFetching = true
        isLoadingSubject.send(true)

        userSearchService.searchUser(nickname: query)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    self.isFetching = false
                    self.isLoadingSubject.send(false)

                    if case .failure(let error) = completion {
                        self.errorMessageSubject.send(error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] users in
                    guard let self else { return }
                    self.searchResults = users
                    self.dataFetchedSubject.send()
                }
            )
            .store(in: &cancellables)
    }
}
