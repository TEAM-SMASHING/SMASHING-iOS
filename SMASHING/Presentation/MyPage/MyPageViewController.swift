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
            NavigationManager.shared.pop()
        }

        mainView.logoutAction = { [weak self] in
            guard let self else { return }
            let popup = ConfirmPopupViewController(
                title: "로그아웃",
                message: "정말 로그아웃 하시겠습니까?",
                cancelTitle: "취소",
                confirmTitle: "로그아웃"
            )
            popup.onConfirmTapped = { [weak self] in
                // 로그아웃 API 연동
            }
            present(popup, animated: true)
        }

        mainView.signoutAction = { [weak self] in
            guard let self else { return }
            NavigationManager.shared.push(SignOutViewController())
        }

        mainView.privacyPolicyAction = { [weak self] in
            guard let self else { return }
            present(PrivacyWebVC(), animated: true)
        }

        mainView.termsOfServiceAction = { [weak self] in
            guard let self else { return }
            present(TermsOfUseWebVC(), animated: true)
        }
    }
}

import SwiftUI
@available(iOS 18.0, *)
#Preview {
    MyPageViewController()
}
