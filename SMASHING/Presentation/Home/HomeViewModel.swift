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
    
    init(regionService: RegionServiceProtocol) {
        self.regionService = regionService
    }
    
    enum Input {
        //Life Cycle
        case viewDidLoad
        case viewWillAppear
        
        //매칭 섹션
        case matchingResultCreateButtonTapped
        case matchingSeeAllTapped
        
        //추천 유저 섹션
        case recommendedUserTapped
        
        //랭킹 섹션
        case rankingUserTapped
        case rankingSeeAllTapped
    }
    
    struct Output {
        
        // TODO: //        let recentMatchings = PassthroughSubject<RecentMatchinDTO, Never>()  /*결과 확정 전인 수락된 매칭 목록 조회 API 오래된순으로 해서 size 1 가져오기
        let recommendedUsers = PassthroughSubject<[RecommendedUserDTO], Never>()
        let rankings = PassthroughSubject<[RankingUserDTO], Never>()

        let isLoading = PassthroughSubject<Bool, Never>()
        let error = PassthroughSubject<Error, Never>()

        let navigateToMatchResultCreate = PassthroughSubject<Int, Never>()
        let navigateToMatchingManageTab = PassthroughSubject<Void, Never>()
        let navigateToSelectedUserProfile = PassthroughSubject<Int, Never>()
        let navigateToRanking = PassthroughSubject<Void, Never>()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let regionService: RegionServiceProtocol
    
    private let output = Output()
    
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
            break
        case .matchingResultCreateButtonTapped:
            break
        case .matchingSeeAllTapped:
            break
        case .recommendedUserTapped:
            break
        case .rankingUserTapped:
            break
        case .rankingSeeAllTapped:
            break
        }
    }
    
    private func fetchHomeData() {
//        fetchRecentMatching()
        output.isLoading.send(true)
        fetchRecommendedUsers()
        fetchRankings()
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
                print("추천 유저 수신")
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
                print("🟢 [HomeViewModel] 랭킹 데이터 수신: \(response.topUsers.count)명")
                           print("🟢 [HomeViewModel] 첫번째 유저: \(response.topUsers.first?.nickname ?? "없음")")
                guard let self else { return }
                
                let top5 = Array(response.topUsers.prefix(5))
                output.rankings.send(top5)
            }
            .store(in: &cancellables)
    }
}
