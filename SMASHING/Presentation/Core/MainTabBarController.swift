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
        case .home:
            <#code#>
        case .matchingSearch:
            <#code#>
        case .matchingManage:
            <#code#>
        case .profile:
            <#code#>
        }
    }
    
    
}

final class MainTabBarController: UITabBarController {
    
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
