//
//  HomeViewModel.swift
//  SMASHING
//
//  Created by 홍준범 on 1/17/26.
//

import Foundation
import Combine

protocol HomeViewModelProtocol: InputOutputProtocol where Input == HomeViewModel.Input, Output == HomeViewModel.Output {
    
}

final class HomeViewModel: HomeViewModelProtocol {
    
    init(regionService: RegionServiceProtocol, matchingConfirmedService: MatchingConfirmedServiceProtocol) {
        self.regionService = regionService
        self.matchingConfirmedService = matchingConfirmedService
    }
    
    enum Input {
        //Life Cycle
        case viewDidLoad
        case viewWillAppear
        
        //매칭 섹션
        case matchingResultCreateButtonTapped(MatchingConfirmedGameDTO)
        case matchingResultConfirmButtonTapped(MatchingConfirmedGameDTO)
        case matchingSeeAllTapped
        
        //추천 유저 섹션
        case recommendedUserTapped(userId: String)
        
        //랭킹 섹션
        case rankingUserTapped(userId: String)
        case rankingSeeAllTapped
        
        // 알림 아이콘 탭
        case notificationTapped
    }
    
    struct Output {
        
        let recentMatchings = PassthroughSubject<[MatchingConfirmedGameDTO], Never>()
        let recommendedUsers = PassthroughSubject<[RecommendedUserDTO], Never>()
        let rankings = PassthroughSubject<[RankingUserDTO], Never>()
        
        let isLoading = PassthroughSubject<Bool, Never>()
        let error = PassthroughSubject<Error, Never>()
        
        let navToMatchResultCreate = PassthroughSubject<MatchingConfirmedGameDTO, Never>()
        let navToMatchResultConfirm = PassthroughSubject<MatchingConfirmedGameDTO, Never>()
        let navToMatchingManageTab = PassthroughSubject<Void, Never>()
        let navToSelectedUserProfile = PassthroughSubject<String, Never>()
        let navToRanking = PassthroughSubject<Void, Never>()
        let navToNotification = PassthroughSubject<Void, Never>()
    }
    private var cancellables = Set<AnyCancellable>()
    
    private let regionService: RegionServiceProtocol
    private let matchingConfirmedService: MatchingConfirmedServiceProtocol
    
    let output = Output()
    
    func transform(input: AnyPublisher<Input, Never>) -> Output {
        input
            .sink { [weak self] input in
                guard let self else { return }
                self.handleInput(input)
            }
            .store(in: &cancellables)
        
        return output
    }
    
    private func handleInput(_ input: Input) {
        switch input {
        case .viewDidLoad:
            fetchHomeData()
        case .viewWillAppear:
            fetchHomeData()
        case .matchingResultCreateButtonTapped(let gameData):
            output.navToMatchResultCreate.send(gameData)
        case .matchingResultConfirmButtonTapped(let gameData):
            output.navToMatchResultConfirm.send(gameData)
        case .matchingSeeAllTapped:
            output.navToMatchingManageTab.send()
        case .recommendedUserTapped(let userId):
            output.navToSelectedUserProfile.send(userId)
        case .rankingUserTapped(let userId):
            output.navToSelectedUserProfile.send(userId)
        case .rankingSeeAllTapped:
            output.navToRanking.send()
        case .notificationTapped:
            output.navToNotification.send()
        }
    }
    
    private func fetchHomeData() {
        output.isLoading.send(true)
        fetchRecentMatching()
        fetchRecommendedUsers()
        fetchRankings()
    }
    
    private func fetchRecentMatching() {
        matchingConfirmedService.getConfirmedGameList(snapshotAt: nil, cursor: nil, size: 1, order: "oldest")
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.output.isLoading.send(false)
                if case .failure(let error) = completion {
                    self.output.error.send(error)
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                output.recentMatchings.send(response.results)
            }
            .store(in: &cancellables)
    }
    
    private func fetchRecommendedUsers() {
        regionService.getRecommendedUsers()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.output.isLoading.send(false)
                if case .failure(let error) = completion {
                    self.output.error.send(error)
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                output.recommendedUsers.send(response.recommendedUsers)
            }
            .store(in: &cancellables)
    }
    
    private func fetchRankings() {
        regionService.getLocalRanking()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.output.isLoading.send(false)
                if case .failure(let error) = completion {
                    self.output.error.send(error)
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                
                let top5 = Array(response.topUsers.prefix(5))
                output.rankings.send(top5)
            }
            .store(in: &cancellables)
    }
}
