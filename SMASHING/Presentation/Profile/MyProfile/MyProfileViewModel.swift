//
//  MyProfileViewModel.swift
//  SMASHING
//
//  Created by 이승준 on 1/21/26.
//

import Combine
import Foundation

protocol MyProfileViewModelProtocol: InputOutputProtocol where Input == MyProfileViewModel.Input, Output == MyProfileViewModel.Output{
    var reviewPreviews: [RecentReviewResult] { get }
}

final class MyProfileViewModel: MyProfileViewModelProtocol {
    
    enum Input {
        case viewDidLoad
        case viewWillAppear
        case sportsCellTapped(Sports?)
        case addSportsTapped
        case tierExplanationTapped
        case seeAllReviewsTapped
    }

    struct Output {
        let myProfileFetched = PassthroughSubject<MyProfileListResponse, Never>()
        let myReviewSummaryFetched = PassthroughSubject<ReviewSummaryResponse, Never>()
        let myRecentReviewListFetched = PassthroughSubject<[RecentReviewResult], Never>()
        let navigateToAddSports = PassthroughSubject<Void, Never>()
        let navToTierExplanation = PassthroughSubject<Void, Never>()
        let navToSeeAllReviews = PassthroughSubject<Void, Never>()
    }

    let output = Output()
    var reviewPreviews: [RecentReviewResult] = []
    private var userProfileService: UserProfileService
    private var userReviewService: UserReviewServiceProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(
        userProfileService: UserProfileService,
        userReviewService: UserReviewServiceProtocol,
    ) {
        self.userProfileService = userProfileService
        self.userReviewService = userReviewService
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> Output {
        input
            .sink { [weak self] input in
                guard let self else { return }
                switch input {
                case .viewDidLoad, .viewWillAppear:
                    userProfileService.fetchMyProfiles()
                        .receive(on: DispatchQueue.main)
                        .sink { _ in
                        } receiveValue: { [weak self] response in
                            guard let self else { return }
                            self.storeSportsCode(from: response)
                            output.myProfileFetched.send(response)
                        }
                        .store(in: &cancellables)
                    
                    userReviewService.fetchMyRecentReviews(size: 8, cursor: nil)
                        .receive(on: DispatchQueue.main)
                        .sink { _ in
                        } receiveValue: { [weak self] response in
                            guard let self else { return }
                            self.reviewPreviews = response.results
                            output.myRecentReviewListFetched.send(response.results)
                        }
                        .store(in: &cancellables)
                    
                    userReviewService.fetchMyReviewSummary()
                        .receive(on: DispatchQueue.main)
                        .sink { _ in
                        } receiveValue: { [weak self] response in
                            guard let self else { return }
                            output.myReviewSummaryFetched.send(response)
                        }
                        .store(in: &cancellables)
                case .sportsCellTapped(let sport):
                    if let sport = sport {
                        // TODO: 해당 종목의 프로필로 데이터 전환 로직 (updateActiveProfile 등 호출 가능)
                    } else {
                        output.navigateToAddSports.send()
                    }
                case .addSportsTapped:
                    break
                case .tierExplanationTapped:
                    output.navToTierExplanation.send()
                case .seeAllReviewsTapped:
                    output.navToSeeAllReviews.send()
                }
            }
            .store(in: &cancellables)
        return output
    }

    private func storeSportsCode(from response: MyProfileListResponse) {
        guard let userId = KeychainService.get(key: Environment.userIdKey), !userId.isEmpty else {
            return
        }
        let key = "\(Environment.sportsCodeKeyPrefix).\(userId)"
        _ = KeychainService.add(key: key, value: response.activeProfile.sportCode.rawValue)
    }
}
