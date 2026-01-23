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

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        
        SSEService.shared.eventPublisher
            .sink { [weak self] payload in
                self?.handleNotification(type: payload)
            }
            .store(in: &cancellables)
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
                    case .navSearchUser:
                        tabBarController.selectedIndex = 1
                    default:
                        break
                    }
                }
            }
            
            if let matchingSearchCoordinator = coordinator as? MatchingSearchCoordinator {
                matchingSearchCoordinator.navAction = { [weak self] in
                    guard let self else { return }
                    tabBarController.selectedIndex = 2
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.goToMatchManage(index: 1)
                        self.refreshSentRequests()
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
        }
        else if index == 1 {
            matchingManageVC.moveToPage(tab: .sent)
        } else if index == 2 {
            matchingManageVC.moveToPage(tab: .confirmed)
        }
    }

    private func refreshSentRequests() {
        guard let navVC = tabBarController.viewControllers?[2] as? UINavigationController,
              let matchingManageVC = navVC.viewControllers.first as? MatchingManageViewController else {
            return
        }
        matchingManageVC.refreshSentRequests()
    }
    
    private func handleNotification(type: SseEventType) {
        switch type {
        case .matchingReceived, .matchingAcceptNotificationCreated:
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard let tabBar = self.navigationController.viewControllers.last as? UITabBarController else { return }
                if let selectedNav = tabBar.selectedViewController as? UINavigationController,
                   let topVC = selectedNav.topViewController as? ToastDisplayable {
                    topVC.showToast(type: type)
                } else if let topVC = tabBar.selectedViewController as? ToastDisplayable {
                    topVC.showToast(type: type)
                }
            }
        case .systemConnected:
            break
            // print("SSE 연결 성공!")
        case .matchingRequestNotificationCreated:
            print("매칭 요청 알림 생성")
        case .matchingUpdated:
            print("매칭 업데이트")
        case .gameUpdated:
            print("게임 정보 업데이트")
        case .gameResultSubmittedNotificationCreated:
            print("게임 결과 제출 알림 생성")
        case .gameResultRejectedNotificationCreated:
            print("게임 결과 반려 알림 생성")
        case .reviewReceivedNotificationCreated:
            print("리뷰가 받아들여짐")
        case .acceptMatching:
            print("매칭 수락함")
        }
    }
}
