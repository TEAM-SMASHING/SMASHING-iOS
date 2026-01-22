//
//  TabBarCoordinator.swift
//  SMASHING
//
//  Created by 이승준 on 1/12/26.
//

import Combine
import UIKit

final class TabBarCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    
    var controllers: [UIViewController] = []
    let factory = DefaultTabBarFlowFactory()
    let tabBarController = MainTabBarController()
    
    private var cancellables = Set<AnyCancellable>()
    private let sseService = SSEService()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        
        sseService.eventPublisher
            .sink { [weak self] payload in
                self?.handleNotification(payload)
            }
            .store(in: &cancellables)
        
        startListening()
    }

    func start() {
        MainTabBarController.Tab.allCases.forEach { tab in
            let (coordinator, navController) = factory.makeTabFlow(for: tab)
            
            if let homeCoordinator = coordinator as? HomeCoordinator {
                homeCoordinator.navAction = { [weak self] nav in
                    guard let self else { return }
                    switch nav {
                    case .navConfirmedMatchManage:
                        tabBarController.selectedIndex = 2
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.goToMatchManage(index: 0)
                        }
                    case .navRequestedMatchManage:
                        tabBarController.selectedIndex = 2
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.goToMatchManage(index: 2)
                        }
                    }
                }
            }
            
            MainTabBarController.setupTabBarItem(for: navController, with: tab)
            
            childCoordinators.append(coordinator)
            controllers.append(navController)
            
            coordinator.start()
        }
        
        tabBarController.viewControllers = controllers
        
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(tabBarController, animated: false)
    }
    
    func goToMatchManage(index: Int) {
        guard let navVC = tabBarController.viewControllers?[2] as? UINavigationController,
              let matchingManageVC = navVC.viewControllers.first as? MatchingManageViewController else {
            return
        }
        if index == 0 {
            matchingManageVC.moveToPage(tab: .received)
        } else if index == 2 {
            matchingManageVC.moveToPage(tab: .confirmed)
        }
    }
    
    func startListening() {
        sseService.connect(accessToken: KeychainService.get(key: Environment.accessTokenKey)!)
    }
    
    private func handleNotification(_ payload: SSEEventPayload) {
        switch payload.type {
        case .matchingReceived:
            print("매칭 요청이 왔어요!")
        case .systemConnected:
            print("SSE 연결 성공!")
        default:
            break
        }
    }
}
