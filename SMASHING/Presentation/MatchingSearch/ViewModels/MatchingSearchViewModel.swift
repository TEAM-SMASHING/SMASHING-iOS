//
//  MatchingSearchViewModel.swift
//  SMASHING
//
//  Created by JIN on 1/20/26.
//

import Foundation
import Combine

protocol MatchingSearchViewModelProtocol: InputOutputProtocol
where Input == MatchingSearchViewModel.Input, Output == MatchingSearchViewModel.Output {
}

final class MatchingSearchViewModel: MatchingSearchViewModelProtocol {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case refresh
        case loadMore
        case genderFilterChanged(Gender?)
        case tierFilterChanged(String?)
        case userCellTapped(String)
    }

    // MARK: - Output

    struct Output {
        let userList = CurrentValueSubject<[MatchingSearchUserProfileDTO], Never>([])
        let isLoading = PassthroughSubject<Bool, Never>()
        let isLoadingMore = PassthroughSubject<Bool, Never>()
        let errorMessage = PassthroughSubject<String, Never>()
        let navigateToUserProfile = PassthroughSubject<String, Never>()
    }

    // MARK: - Properties

    private let service: MatchingSearchServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    let output = Output()

    // Pagination
    private var snapshotAt: String?
    private var nextCursor: String?
    private var hasNext: Bool = false
    private var isLoadingPage: Bool = false

    // Filters
    private var currentGenderFilter: Gender?
    private var currentTierFilter: String?

    // MARK: - Init

    init(service: MatchingSearchServiceProtocol) {
        self.service = service
    }

    // MARK: - Transform

    func transform(input: AnyPublisher<Input, Never>) -> Output {
        input
            .sink { [weak self] input in
                guard let self else { return }
                self.handleInput(input)
            }
            .store(in: &cancellables)

        return output
    }

    // MARK: - Handle Input

    private func handleInput(_ input: Input) {
        switch input {
        case .viewDidLoad, .refresh:
            resetAndFetch()

        case .loadMore:
            fetchNextPage()

        case .genderFilterChanged(let gender):
            self.currentGenderFilter = gender
            resetAndFetch()

        case .tierFilterChanged(let tier):
            self.currentTierFilter = tier
            resetAndFetch()

        case .userCellTapped(let userId):
            output.navigateToUserProfile.send(userId)
        }
    }

    // MARK: - Private Methods

    private func resetAndFetch() {
        snapshotAt = nil
        nextCursor = nil
        hasNext = false
        output.userList.send([])
        fetchUserList(isInitial: true)
    }

    private func fetchNextPage() {
        guard hasNext, !isLoadingPage else { return }
        fetchUserList(isInitial: false)
    }

    private func fetchUserList(isInitial: Bool) {
        isLoadingPage = true

        if isInitial {
            output.isLoading.send(true)
        } else {
            output.isLoadingMore.send(true)
        }

        service.getUserProfileList(
            cursor: nextCursor,
            size: 20,
            gender: currentGenderFilter,
            tier: currentTierFilter
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            guard let self else { return }
            self.isLoadingPage = false

            if isInitial {
                self.output.isLoading.send(false)
            } else {
                self.output.isLoadingMore.send(false)
            }

            if case .failure(let error) = completion {
                self.output.errorMessage.send(error.localizedDescription)
            }
        } receiveValue: { [weak self] response in
            guard let self else { return }

            self.snapshotAt = response.snapshotAt
            self.nextCursor = response.nextCursor
            self.hasNext = response.hasNext

            if isInitial {
                self.output.userList.send(response.results)
            } else {
                let currentList = self.output.userList.value
                self.output.userList.send(currentList + response.results)
            }
        }
        .store(in: &cancellables)
    }
}
