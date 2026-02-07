//
//  NavigationManager.swift
//  SMASHING
//
//  Created by Claude on 2/6/26.
//

import Combine
import UIKit

final class NavigationManager {

    // MARK: - Singleton

    static let shared = NavigationManager()

    // MARK: - Properties

    private(set) var rootNavigationController: UINavigationController?
    private(set) var tabBarController: MainTabBarController?

    private var cancellables = Set<AnyCancellable>()

    private init() {}

    // MARK: - Setup

    func setRootNavigationController(_ navigationController: UINavigationController) {
        self.rootNavigationController = navigationController
    }

    func setTabBarController(_ tabBarController: MainTabBarController) {
        self.tabBarController = tabBarController
    }

    // MARK: - Root Flow

    func resetRootFlow(to viewControllers: [UIViewController], animated: Bool = false) {
        rootNavigationController?.setViewControllers(viewControllers, animated: animated)
    }

    func setRootNavigationBarHidden(_ hidden: Bool, animated: Bool = false) {
        rootNavigationController?.setNavigationBarHidden(hidden, animated: animated)
    }

    // MARK: - Tab Navigation

    func switchTab(to tab: MainTabBarController.Tab) {
        tabBarController?.selectedIndex = tab.rawValue
    }

    var currentTabNavigationController: UINavigationController? {
        tabBarController?.selectedViewController as? UINavigationController
    }

    func navigationController(for tab: MainTabBarController.Tab) -> UINavigationController? {
        tabBarController?.viewControllers?[tab.rawValue] as? UINavigationController
    }

    // MARK: - Push

    func push(
        _ viewController: UIViewController,
        on tab: MainTabBarController.Tab? = nil,
        animated: Bool = true,
        hidesBottomBar: Bool = false
    ) {
        let nav = resolveNavigationController(for: tab)
        viewController.hidesBottomBarWhenPushed = hidesBottomBar
        nav?.pushViewController(viewController, animated: animated)
    }

    func pushToRoot(_ viewController: UIViewController, animated: Bool = true) {
        rootNavigationController?.pushViewController(viewController, animated: animated)
    }

    // MARK: - Pop

    @discardableResult
    func pop(on tab: MainTabBarController.Tab? = nil, animated: Bool = true) -> UIViewController? {
        let nav = resolveNavigationController(for: tab)
        return nav?.popViewController(animated: animated)
    }

    @discardableResult
    func popToRoot(on tab: MainTabBarController.Tab? = nil, animated: Bool = true) -> [UIViewController]? {
        let nav = resolveNavigationController(for: tab)
        return nav?.popToRootViewController(animated: animated)
    }

    @discardableResult
    func popFromRoot(animated: Bool = true) -> UIViewController? {
        rootNavigationController?.popViewController(animated: animated)
    }

    // MARK: - Modal Presentation

    func present(
        _ viewController: UIViewController,
        on tab: MainTabBarController.Tab? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        let nav = resolveNavigationController(for: tab)
        let presenter = nav?.topViewController ?? nav
        presenter?.present(viewController, animated: animated, completion: completion)
    }

    func dismiss(
        on tab: MainTabBarController.Tab? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        let nav = resolveNavigationController(for: tab)
        let presenter = nav?.topViewController ?? nav
        presenter?.dismiss(animated: animated, completion: completion)
    }

    // MARK: - Cross-Tab Navigation

    enum MatchManagePage {
        case received
        case sent
        case confirmed

        var headerTab: MatchingManageHeaderView.Tab {
            switch self {
            case .received:  return .received
            case .sent:      return .sent
            case .confirmed: return .confirmed
            }
        }
    }

    func navigateToMatchManage(page: MatchManagePage) {
        switchTab(to: .matchingManage)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let nav = self?.navigationController(for: .matchingManage),
                  let matchingManageVC = nav.viewControllers.first as? MatchingManageViewController else {
                return
            }
            matchingManageVC.moveToPage(tab: page.headerTab)
        }
    }

    func navigateToMatchManageSentAndRefresh() {
        switchTab(to: .matchingManage)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let nav = self?.navigationController(for: .matchingManage),
                  let matchingManageVC = nav.viewControllers.first as? MatchingManageViewController else {
                return
            }
            matchingManageVC.moveToPage(tab: MatchManagePage.sent.headerTab)
            matchingManageVC.refreshSentRequests()
        }
    }

    func navigateToMatchingSearch() {
        switchTab(to: .matchingSearch)
    }

    // MARK: - Toast

    func showToast(type: SseEventType) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            if let nav = self.currentTabNavigationController,
               let topVC = nav.topViewController as? ToastDisplayable {
                topVC.showToast(type: type)
            } else if let topVC = self.tabBarController?.selectedViewController as? ToastDisplayable {
                topVC.showToast(type: type)
            }
        }
    }

    // MARK: - NotificationAction Handling

    func handleNotificationAction(_ action: NotificationAction) {
        switch action {
        case .navConfirmedMatchManage:
            navigateToMatchManage(page: .received)
        case .navRequestedMatchManage:
            navigateToMatchManage(page: .confirmed)
        case .navSentRequestManage:
            navigateToMatchManageSentAndRefresh()
        case .navSearchUser:
            navigateToMatchingSearch()
        }
    }

    // MARK: - SSE Event Handling

    func subscribeToSSEEvents() {
        SSEService.shared.eventPublisher
            .sink { [weak self] payload in
                self?.handleSSEEvent(type: payload)
            }
            .store(in: &cancellables)
    }

    private func handleSSEEvent(type: SseEventType) {
        switch type {
        case .matchingReceived, .matchingAcceptNotificationCreated:
            showToast(type: type)
        case .systemConnected:
            break
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

    // MARK: - Utility

    var topViewController: UIViewController? {
        if let nav = currentTabNavigationController {
            return nav.topViewController
        }
        return rootNavigationController?.topViewController
    }

    // MARK: - Tab Bar Setup

    func setupTabBar() {
        let tabBar = MainTabBarController()
        setTabBarController(tabBar)
        subscribeToSSEEvents()

        var controllers: [UIViewController] = []
        for tab in MainTabBarController.Tab.allCases {
            let nav = UINavigationController()
            let rootVC = makeRootViewController(for: tab)
            nav.pushViewController(rootVC, animated: false)
            MainTabBarController.setupTabBarItem(for: nav, with: tab)
            controllers.append(nav)
        }

        tabBar.viewControllers = controllers
        setRootNavigationBarHidden(true)
        pushToRoot(tabBar, animated: false)
    }

    private func makeRootViewController(for tab: MainTabBarController.Tab) -> UIViewController {
        switch tab {
        case .home:           return HomeViewController()
        case .matchingSearch: return MatchingSearchViewController()
        case .matchingManage: return MatchingManageViewController()
        case .profile:        return MyProfileViewController()
        }
    }

    // MARK: - Private

    private func resolveNavigationController(for tab: MainTabBarController.Tab?) -> UINavigationController? {
        if let tab {
            return navigationController(for: tab)
        }
        return currentTabNavigationController ?? rootNavigationController
    }
}
