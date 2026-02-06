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

    /// 루트 네비게이션 스택을 완전히 교체합니다.
    /// 로그인 -> 온보딩 -> 탭바 등 플로우 전환 시 사용합니다.
    func resetRootFlow(to viewControllers: [UIViewController], animated: Bool = false) {
        rootNavigationController?.viewControllers.removeAll()
        rootNavigationController?.setViewControllers(viewControllers, animated: animated)
    }

    /// 루트 네비게이션 바 표시 여부를 설정합니다.
    func setRootNavigationBarHidden(_ hidden: Bool, animated: Bool = false) {
        rootNavigationController?.setNavigationBarHidden(hidden, animated: animated)
    }

    // MARK: - Tab Navigation

    /// 특정 탭으로 전환합니다.
    func switchTab(to tab: MainTabBarController.Tab) {
        tabBarController?.selectedIndex = tab.rawValue
    }

    /// 현재 선택된 탭의 UINavigationController를 반환합니다.
    var currentTabNavigationController: UINavigationController? {
        tabBarController?.selectedViewController as? UINavigationController
    }

    /// 특정 탭의 UINavigationController를 반환합니다.
    func navigationController(for tab: MainTabBarController.Tab) -> UINavigationController? {
        tabBarController?.viewControllers?[tab.rawValue] as? UINavigationController
    }

    // MARK: - Push

    /// 현재 활성 탭(또는 지정된 탭)의 네비게이션 스택에 ViewController를 push합니다.
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

    /// 루트 네비게이션 컨트롤러에 직접 push합니다.
    /// 탭바가 아직 설정되지 않은 로그인/온보딩 플로우에서 사용합니다.
    func pushToRoot(_ viewController: UIViewController, animated: Bool = true) {
        rootNavigationController?.pushViewController(viewController, animated: animated)
    }

    // MARK: - Pop

    /// 현재 활성 탭(또는 지정된 탭)의 네비게이션 스택에서 pop합니다.
    @discardableResult
    func pop(on tab: MainTabBarController.Tab? = nil, animated: Bool = true) -> UIViewController? {
        let nav = resolveNavigationController(for: tab)
        return nav?.popViewController(animated: animated)
    }

    /// 현재 활성 탭(또는 지정된 탭)의 네비게이션 스택을 루트까지 pop합니다.
    @discardableResult
    func popToRoot(on tab: MainTabBarController.Tab? = nil, animated: Bool = true) -> [UIViewController]? {
        let nav = resolveNavigationController(for: tab)
        return nav?.popToRootViewController(animated: animated)
    }

    /// 루트 네비게이션 컨트롤러에서 pop합니다.
    @discardableResult
    func popFromRoot(animated: Bool = true) -> UIViewController? {
        rootNavigationController?.popViewController(animated: animated)
    }

    // MARK: - Modal Presentation

    /// 현재 활성 탭(또는 지정된 탭)의 최상위 ViewController에서 모달을 present합니다.
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

    /// 현재 활성 탭(또는 지정된 탭)의 최상위 ViewController에서 모달을 dismiss합니다.
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

    /// 매칭 관리 탭으로 이동하고 특정 페이지를 표시합니다.
    func navigateToMatchManage(page: MatchManagePage) {
        switchTab(to: .matchingManage)

        DispatchQueue.main.async { [weak self] in
            guard let nav = self?.navigationController(for: .matchingManage),
                  let matchingManageVC = nav.viewControllers.first as? MatchingManageViewController else {
                return
            }
            matchingManageVC.moveToPage(tab: page.headerTab)
        }
    }

    /// 매칭 관리 탭의 보낸 요청으로 이동하고, 목록을 새로고침합니다.
    func navigateToMatchManageSentAndRefresh() {
        navigateToMatchManage(page: .sent)

        DispatchQueue.main.async { [weak self] in
            guard let nav = self?.navigationController(for: .matchingManage),
                  let matchingManageVC = nav.viewControllers.first as? MatchingManageViewController else {
                return
            }
            matchingManageVC.refreshSentRequests()
        }
    }

    /// 매칭 탐색 탭으로 이동합니다.
    func navigateToMatchingSearch() {
        switchTab(to: .matchingSearch)
    }

    // MARK: - Toast

    /// 현재 활성 화면에 Toast 메시지를 표시합니다.
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

    /// 기존 Coordinator에서 사용하던 NotificationAction을 처리합니다.
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

    /// SSE 이벤트를 구독하고 Toast를 표시합니다.
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

    /// 현재 최상위에 표시된 UIViewController를 반환합니다.
    var topViewController: UIViewController? {
        if let nav = currentTabNavigationController {
            return nav.topViewController
        }
        return rootNavigationController?.topViewController
    }

    // MARK: - Private

    private func resolveNavigationController(for tab: MainTabBarController.Tab?) -> UINavigationController? {
        if let tab {
            return navigationController(for: tab)
        }
        return currentTabNavigationController ?? rootNavigationController
    }
}
