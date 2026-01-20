//
//  HomeCoordinator.swift
//  SMASHING
//
//  Created by 이승준 on 1/12/26.
//

import UIKit
import Combine

final class HomeCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    private var cancellables = Set<AnyCancellable>()
    
    // TODO: 유저 정보 API 연동 후 수정
    private var myUserId: String {
        return KeychainService.get(key: Environment.userIdKey) ?? ""
    }
    
    private var myNickname: String {
        return KeychainService.get(key: Environment.nicknameKey) ?? ""
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        let regionService = RegionService()
        let matchingConfirmedService = MatchingConfirmedService()
        let viewModel = HomeViewModel(regionService: regionService, matchingConfirmedService: matchingConfirmedService)
        let homeVC = HomeViewController(viewModel: viewModel)
        
        bindNavigationEvents(output: viewModel.output)
        navigationController.pushViewController(homeVC, animated: true)
    }
    
    private func bindNavigationEvents(output: HomeViewModel.Output) {
        
        output.navToMatchResultCreate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] gameData in
                self?.showMatchResultCreate(with: gameData)
            }
            .store(in: &cancellables)
        
        output.navToRanking
            .sink { [weak self] in
                self?.showRanking()
            }
            .store(in: &cancellables)
    }
    
    private func showMatchResultCreate(with gameData: MatchingConfirmedGameDTO) {
        let vm = MatchResultCreateViewModel(gameData: gameData, myUserId: myUserId, myNickname: myNickname)
        let vc = MatchResultCreateViewController(viewModel: vm)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showRanking() {
        let regionService = RegionService()
        let viewModel = RankingViewModel(regionService: regionService)
        let rankingVC = RankingViewController(viewModel: viewModel)
        navigationController.pushViewController(rankingVC, animated: true)
    }
}
