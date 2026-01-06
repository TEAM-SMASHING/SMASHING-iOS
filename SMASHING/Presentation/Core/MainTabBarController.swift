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
    
    private var factory: TabBarSceneFactoryProtocol = TabBarSceneFactory()
    
    static weak var shared: MainTabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarAppearance()
        
    }
    
    private func setTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .darkGray
        
        let itemAppearance = UITabBarItemAppearance()
        
        appearance.stackedLayoutAppearance = itemAppearance
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
}
