//
//  MyPageViewController.swift
//  SMASHING
//
//  Created by 이승준 on 3/4/26.
//

import UIKit

final class MyPageViewController: BaseViewController {

    private let mainView = MyPageView()

    override func viewDidLoad() {
        view = mainView

        mainView.leftButtonAction = { [weak self] in
            guard let self else { return }
        }

        mainView.logoutAction = { [weak self] in
            guard let self else { return }
        }

        mainView.signoutAction = { [weak self] in
            guard let self else { return }
        }

        mainView.privacyPolicyAction = { [weak self] in
            guard let self else { return }
        }

        mainView.termsOfServiceAction = { [weak self] in
            guard let self else { return }
        }
    }
}
