//
//  MyPageViewModel.swift
//  SMASHING
//
//  Created by 이승준 on 3/29/26.
//

import Combine
import Foundation

final class MyPageViewModel {

    enum Input {
        case viewDidLoad
    }

    struct Output {
        let profileFetched = PassthroughSubject<MyProfileListResponse, Never>()
    }

    let output = Output()
    private let userProfileService: UserProfileServiceType
    private var cancellables = Set<AnyCancellable>()

    init(userProfileService: UserProfileServiceType = UserProfileService()) {
        self.userProfileService = userProfileService
    }

    func transform(input: AnyPublisher<Input, Never>) -> Output {
        input
            .sink { [weak self] input in
                guard let self else { return }
                switch input {
                case .viewDidLoad:
                    self.fetchProfile()
                }
            }
            .store(in: &cancellables)
        return output
    }

    private func fetchProfile() {
        userProfileService.fetchMyProfiles()
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] response in
                self?.output.profileFetched.send(response)
            }
            .store(in: &cancellables)
    }
}
