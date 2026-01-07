//
//  MainTabBarController.swift
//  SMASHING
//
//  Created by JIN on 1/6/26.
//

import UIKit
import SnapKit

import Then

protocol TabBarSceneFactoryProtocol {
    
    func makeViewController(for tab: MainTabBarController.Tab) -> UIViewController
}

final class TabBarSceneFactory: TabBarSceneFactoryProtocol {
    func makeViewController(for tab: MainTabBarController.Tab) -> UIViewController {
        switch tab {
        case .home: return HomViewController()
        case .matchingSearch: return MatchingSearchViewController()
        case .matchingManage: return MatchingManageViewController()
        case .profile: return ProfileViewController()
        }
    }
    
    
}

final class MainTabBarController: UITabBarController {

    //MARK: - Tab

    enum Tab: Int, CaseIterable {
        case home = 0
        case matchingSearch
        case matchingManage
        case profile

        var title: String {
            switch self {
            case .home: return "홈"
            case .matchingSearch: return "매칭 검색"
            case .matchingManage: return "매칭 관리"
            case .profile: return "프로필"

            }
        }

        var image: UIImage {
            switch self {
            case .home: return UIImage(resource: .icHomeUnselected)
            case .matchingSearch: return UIImage(resource: .icSearchUnselected)
            case .matchingManage: return UIImage(resource: .icTrophyUnselected)
            case .profile: return UIImage(resource: .icProfileUnselected)
            }
        }

        var selectedImage: UIImage {
            switch self {
            case .home: return UIImage(resource: .icHomeSelected)
            case .matchingSearch: return UIImage(resource: .icSearchSelected)
            case .matchingManage: return UIImage(resource: .icTrophySelected)
            case .profile: return UIImage(resource: .icProfileSelected)
            }
        }
    }

    // MARK: - Properties

    private var factory: TabBarSceneFactoryProtocol

    private let defaultTab: Tab = .home

    static weak var shared: MainTabBarController?

    // MARK: - Initializers

    init(factory: TabBarSceneFactoryProtocol) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        MainTabBarController.shared = self

        self.setupCustomTabBar()
        self.setupViewControllers()
        self.selectedIndex = self.defaultTab.rawValue
    }

    // MARK: - Public Methods

    func switchToTab(_ tab: Tab) {
        self.selectedIndex = tab.rawValue
        if let nav = self.selectedViewController as? UINavigationController {
            nav.popToRootViewController(animated: true)
        }
    }

    // MARK: - Setup

    private func setupViewControllers() {
        self.viewControllers = Tab.allCases.map { tab in
            let viewController = self.factory.makeViewController(for: tab)
            let icon = tab.image.withRenderingMode(.alwaysOriginal)
            let selectedIcon = tab.selectedImage.withRenderingMode(.alwaysOriginal)

            viewController.tabBarItem = UITabBarItem(
                title: tab.title,
                image: icon,
                selectedImage: selectedIcon
            )
            viewController.tabBarItem.tag = tab.rawValue

            return viewController
        }
    }

}

// MARK: - Custom TabBar Setup

extension MainTabBarController {

        private func setupCustomTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(resource: .Text.primary)
        ]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(resource: .Text.disabled)
        ]

        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
        self.addCustomTabBarBackground()
    }

        private func addCustomTabBarBackground() {
        let customTabBarView = UIView().then {
            $0.backgroundColor = UIColor(resource: .Background.surface)
            $0.layer.cornerRadius = 20
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }

        self.tabBar.insertSubview(customTabBarView, at: 0)
        customTabBarView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
