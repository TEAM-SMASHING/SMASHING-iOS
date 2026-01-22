//
//  RankingViewModel.swift
//  SMASHING
//
//  Created by 홍준범 on 1/18/26.
//

import Foundation
import Combine

protocol RankingViewModelProtocol: InputOutputProtocol where Input == RankingViewModel.Input, Output == RankingViewModel.Output {
    
}

final class RankingViewModel: RankingViewModelProtocol {
    
    init(regionService: RegionServiceProtocol) {
        self.regionService = regionService
    }
    
    enum Input {
        //Life Cycle
        case viewDidLoad
        
        case rankingUserTapped(userId: String)
        case backButtonTapped
    }
    
    struct Output {
        let topThreeUsers = PassthroughSubject<[RankingUserDTO], Never>()
        let rankings = PassthroughSubject<[RankingUserDTO], Never>()
        let myRanking = PassthroughSubject<MyRankingDTO?, Never>()
        
        let isLoading = PassthroughSubject<Bool, Never>()
        let isEmpty = PassthroughSubject<Bool, Never>()
        let error = PassthroughSubject<NetworkError, Never>()
        
        let navigateToUserProfile = PassthroughSubject<String, Never>()
        let navigateBack = PassthroughSubject<Void, Never>()
    }
    
    // MARK: - Properties
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
            fetchRankings()
        case .rankingUserTapped(let userId):
            output.navigateToUserProfile.send(userId)
        case .backButtonTapped:
            output.navigateBack.send()
        }
    }
    
    private func fetchRankings() {
        output.isLoading.send(true)
        
        regionService.getLocalRanking()
            .receive(on: DispatchQueue.main)
            .sink {  [weak self] completion in
                guard let self else { return }
                self.output.isLoading.send(false)
                if case .failure(let error) = completion {
                    self.output.error.send(error)
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                
                let topThreeUsers = Array(response.topUsers.prefix(3))
                self.output.topThreeUsers.send(topThreeUsers)
                
                let rest = Array(response.topUsers.dropFirst(3))
                self.output.rankings.send(rest)
                
                let isEmpty = rest.isEmpty
                self.output.isEmpty.send(isEmpty)
                
                self.output.myRanking.send(response.user)
                
//                let isEmpty = response.topUsers.isEmpty
//                self.output.isEmpty.send(isEmpty)
//                
//                if !isEmpty {
//                    let topThreeUsers = Array(response.topUsers.prefix(3))
//                    self.output.topThreeUsers.send(topThreeUsers)
//                    
//                    let rest = Array(response.topUsers.dropFirst(3))
//                    self.output.rankings.send(rest)
//                }
//                
//                self.output.myRanking.send(response.user)
            }
            .store(in: &cancellables)
    }
    
}
