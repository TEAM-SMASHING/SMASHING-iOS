//
//  UserProfileViewModel.swift
//  SMASHING
//
//  Created by JIN on 1/21/26.
//

import Foundation
import Combine

protocol UserProfileViewModelProtocol: InputOutputProtocol
where Input == UserProfileViewModel.Input, Output == UserProfileViewModel.Output {
    var reviewPreviews: [RecentReviewResult] { get }
}

final class UserProfileViewModel: UserProfileViewModelProtocol {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case refresh
        case challengeConfirmed
    }

    // MARK: - Output

    struct Output {
        let userProfile = CurrentValueSubject<OtherUserProfileResponse?, Never>(nil)
        let isLoading = PassthroughSubject<Bool, Never>()
        let errorMessage = PassthroughSubject<String, Never>()
        let challengeRequestCompleted = PassthroughSubject<Void, Never>()
    }

    // MARK: - Properties

    private let userId: String
    private let sport: Sports
    private let service: UserProfileServiceType
    private let matchingRequestService: MatchingRequestServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    let output = Output()
    private(set) var reviewPreviews: [RecentReviewResult] = []
    private var receiverProfileId: String?

    // MARK: - Init

    init(
        userId: String,
        sport: Sports,
        service: UserProfileServiceType = UserProfileService(),
        matchingRequestService: MatchingRequestServiceProtocol = MatchingRequestService()
    ) {
        self.userId = userId
        self.sport = sport
        self.service = service
        self.matchingRequestService = matchingRequestService
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
            fetchUserProfile()
        case .challengeConfirmed:
            requestMatching()
        }
    }

    // MARK: - Private Methods

    private func fetchUserProfile() {
        output.isLoading.send(true)

        service.fetchOtherUserProfile(userId: userId, sport: sport)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.output.isLoading.send(false)

                if case .failure(let error) = completion {
                    self.output.errorMessage.send(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                self.receiverProfileId = response.selectedProfile.profileId
                self.output.userProfile.send(response)
            }
            .store(in: &cancellables)
    }

    private func requestMatching() {
        guard let receiverProfileId else {
            output.errorMessage.send("매칭 신청 대상 정보를 찾을 수 없습니다.")
            return
        }

        output.isLoading.send(true)
        matchingRequestService.requestMatching(receiverProfileId: receiverProfileId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.output.isLoading.send(false)
                if case .failure(let error) = completion {
                    self.output.errorMessage.send(error.localizedDescription)
                }
            } receiveValue: { [weak self] in
                self?.output.challengeRequestCompleted.send()
            }
            .store(in: &cancellables)
    }
}
