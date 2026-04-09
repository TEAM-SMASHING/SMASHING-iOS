//
//  MyPageViewController.swift
//  SMASHING
//
//  Created by 이승준 on 3/4/26.
//

import Combine
import SafariServices
import UIKit

final class MyPageViewController: BaseViewController {

    private let mainView = MyPageView()
    private let viewModel = MyPageViewModel()
    private let accountService = UserAccountService()
    private let inputSubject = PassthroughSubject<MyPageViewModel.Input, Never>()
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        view = mainView
        bind()
        setupActions()
        inputSubject.send(.viewDidLoad)
    }

    private func bind() {
        let output = viewModel.transform(input: inputSubject.eraseToAnyPublisher())

        output.profileFetched
            .receive(on: DispatchQueue.main)
            .sink { [weak self] profile in
                self?.mainView.configure(profile: profile)
            }
            .store(in: &cancellables)
    }

    private func setupActions() {
        mainView.leftButtonAction = { [weak self] in
            guard let self else { return }
            NavigationManager.shared.pop()
        }

        mainView.profileAction = {
            let profileVC = MyProfileViewController(showsBackButton: true)
            NavigationManager.shared.push(profileVC, hidesBottomBar: true)
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
                guard let self else { return }
                self.dismiss(animated: true) {
                    self.accountService.logout()
                        .receive(on: DispatchQueue.main)
                        .sink { _ in
                            // 성공·실패 모두 로컬 로그아웃 수행
                            KeychainService.clearAll()
                            NavigationManager.shared.navigateToLogin()
                        } receiveValue: { _ in }
                        .store(in: &self.cancellables)
                }
            }
            present(popup, animated: true)
        }

        mainView.signoutAction = { [weak self] in
            guard let self else { return }
            NavigationManager.shared.push(SignOutViewController())
        }

        mainView.privacyPolicyAction = { [weak self] in
            guard let self else { return }
            guard let url = URL(string: "https://elated-piccolo-63b.notion.site/30b4556d60d18092b22ad0e23a84eee2?pvs=143") else { return }
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        }

        mainView.termsOfServiceAction = { [weak self] in
            guard let self else { return }
            guard let url = URL(string: "https://elated-piccolo-63b.notion.site/30b4556d60d18092b22ad0e23a84eee2") else { return }
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        }
        
        mainView.verionInfoAction = { [weak self] in
            guard let self else { return }
            guard let url = URL(string: "https://elated-piccolo-63b.notion.site/30b4556d60d18010bb2aff85c555cd9e") else { return }
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        }
    }
}

import SwiftUI
@available(iOS 18.0, *)
#Preview {
    MyPageViewController()
}
