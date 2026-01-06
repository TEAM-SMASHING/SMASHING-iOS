//
//  AppSceneFactory.swift
//  SMASHING
//
//  Created by 이승준 on 1/6/26.
//

import UIKit

enum SceneType {
    case login
    case signup
    case main
}

protocol SceneFactory {
    func makeScene(for type: SceneType) -> UIViewController
}

final class AppSceneFactory: SceneFactory {
    func makeScene(for type: SceneType) -> UIViewController {
        switch type {
        default :
            return ViewController()
        }
    }
}
