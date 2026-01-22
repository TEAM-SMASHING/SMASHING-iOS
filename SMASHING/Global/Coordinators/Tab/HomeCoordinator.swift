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
    
    var navAction: ((NotificationAction) -> Void)?

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
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.showRanking()
            }
            .store(in: &cancellables)
        
        output.navToSelectedUserProfile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userId in
                self?.showUserProfile(userId: userId)
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
        rankingVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(rankingVC, animated: true)
    }
    
    private func showNotificationFlow() {
        let notificationCoordinator = NotificationCoordinator(navigationController: navigationController)
        self.childCoordinators.append(notificationCoordinator)
        notificationCoordinator.start()
        
        notificationCoordinator.action = { [weak self] nav in
            self?.navigationController.popViewController(animated: true)
            self?.navAction?(nav)
        }
    }

    private func showUserProfile(userId: String) {
        let viewModel = UserProfileViewModel(userId: userId, sport: currentUserSport())
        let userProfileVC = UserProfileViewController(viewModel: viewModel)
        navigationController.pushViewController(userProfileVC, animated: true)
    }
    
    private func currentUserSport() -> Sports {
        guard let userId = KeychainService.get(key: Environment.userIdKey), !userId.isEmpty else {
            return .badminton
        }

        let key = "\(Environment.sportsCodeKeyPrefix).\(userId)"
        let rawValue = KeychainService.get(key: key)
        guard let rawValue,
              let sport = Sports(rawValue: rawValue) else {
            return .badminton
        }

        return sport
    }
}
