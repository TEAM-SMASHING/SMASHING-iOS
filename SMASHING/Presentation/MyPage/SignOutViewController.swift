//
//  SignOutViewController.swift
//  SMASHING
//
//  Created by 이승준 on 3/8/26.
//

import Combine
import UIKit

final class SignOutViewController: BaseViewController {

    let signOutView = SignOutView()
    let viewModel = SignOutViewModel()
    private let inputSubject = PassthroughSubject<SignOutViewModel.Input, Never>()
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        view = signOutView
        bindActions()
        bind(output: viewModel.transform(input: inputSubject.eraseToAnyPublisher()))
    }

    private func bindActions() {
        signOutView.leftButtonAction = {
            NavigationManager.shared.pop()
        }

        signOutView.checkboxAction = { [weak self] in
            self?.inputSubject.send(.checkBoxTapped)
        }

        signOutView.signoutAction = { [weak self] in
            self?.inputSubject.send(.signoutTapped)
        }
    }

    private func bind(output: SignOutViewModel.Output) {
        output.isButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.signOutView.configure(isSignOutEnabled: isEnabled)
            }
            .store(in: &cancellables)

        // 주의 팝업 표시
        output.showConfirmPopup
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                let popup = ConfirmPopupViewController(
                    title: "정말 탈퇴하시겠습니까?",
                    message: "탈퇴 시 모든 데이터가 삭제되며 복구할 수 없습니다.",
                    cancelTitle: "취소",
                    confirmTitle: "탈퇴"
                )
                popup.onConfirmTapped = { [weak self] in
                    self?.inputSubject.send(.signoutConfirmed)
                }
                self.present(popup, animated: true)
            }
            .store(in: &cancellables)

        // 탈퇴 성공 → 로컬 정보 초기화 후 로그인 화면 이동
        output.signOutSuccess
            .receive(on: DispatchQueue.main)
            .sink {
                KeychainService.clearAll()
                NavigationManager.shared.navigateToLogin()
            }
            .store(in: &cancellables)

        // 탈퇴 API 실패
        output.error
            .receive(on: DispatchQueue.main)
            .sink { error in
                print("[SignOut] 탈퇴 API 실패: \(error)")
            }
            .store(in: &cancellables)
    }
}
