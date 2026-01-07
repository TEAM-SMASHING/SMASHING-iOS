//
//  RootViewSwitcher.swift
//  SMASHING
//
//  Created by 이승준 on 1/6/26.
//

import UIKit

final class RootViewSwitcher {
    static let shared = RootViewSwitcher()
    private init() {}

    func setRoot(_ viewController: UIViewController, animated: Bool = true) {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first else { return }

        window.rootViewController = viewController

        if animated {
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
        
        window.makeKeyAndVisible()
    }
}
