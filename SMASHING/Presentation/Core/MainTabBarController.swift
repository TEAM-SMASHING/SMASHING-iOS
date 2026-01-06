//
//  MainTabBarController.swift
//  SMASHING
//
//  Created by JIN on 1/6/26.
//

import UIKit

protocol TabBarSceneFactoryProtocol {
    
    func makeScene(for tabBarScene: TabBarScene) -> UIViewController
}

enum TabBarScene: String {
    case home
    case matchingManage
    case matchingSearch
    case profile
}


final class TabBarSceneFactory: TabBarSceneFactoryProtocol {
    func makeScene(for tabBarScene: TabBarScene) -> UIViewController {
        switch tabBarScene {
        case .home: return HomViewController()
        case .matchingSearch: return MatchingSearchViewController()
        case .matchingManage: return MatchingManageViewController()
        case .profile: return ProfileViewController()
        }
    }
    
    
}

final class MainTabBarController: UITabBarController {

    // MARK: - Properties

    private var factory: TabBarSceneFactoryProtocol = TabBarSceneFactory()

    static weak var shared: MainTabBarController?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTabBarAppearance()
        self.setupViewControllers()
    }

    // MARK: - Setup

    private func setupViewControllers() {
        let homeVC = self.factory.makeScene(for: .home)
        homeVC.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(resource: .icHomeUnselected),
            selectedImage: UIImage(resource: .icHomeSelected)
        )

        let matchingSearchVC = self.factory.makeScene(for: .matchingSearch)
        matchingSearchVC.tabBarItem = UITabBarItem(
            title: "매칭 검색",
            image: UIImage(resource: .icSearchUnselected),
            selectedImage: UIImage(resource: .icSearchSelected)
        )

        let matchingManageVC = self.factory.makeScene(for: .matchingManage)
        matchingManageVC.tabBarItem = UITabBarItem(
            title: "매칭 관리",
            image: UIImage(resource: .icTrophyUnselected),
            selectedImage: UIImage(resource: .icTrophySelected)
        )

        let profileVC = self.factory.makeScene(for: .profile)
        profileVC.tabBarItem = UITabBarItem(
            title: "프로필",
            image: UIImage(resource: .icProfileUnselected),
            selectedImage: UIImage(resource: .icProfileSelected)
        )

        self.viewControllers = [homeVC, matchingSearchVC, matchingManageVC, profileVC]
    }

    private func setTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .darkGray

        let itemAppearance = UITabBarItemAppearance()

        appearance.stackedLayoutAppearance = itemAppearance
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
    }

}
