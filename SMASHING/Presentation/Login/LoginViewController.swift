//
//  LoginViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/12/26.
//

import Combine
import UIKit

final class LoginViewController: BaseViewController {
    
    // MARK: - Navigation Closures
    
    var onNeedOnboarding: (() -> Void)?
    var onLoginSuccess: (() -> Void)?
    
    // MARK: - Properties
    
    private let viewModel: LoginViewModel
    private let mainView = LoginView()
    private let input = PassthroughSubject<LoginViewModel.Input, Never>()

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init

    init() {
        self.viewModel = LoginViewModel(kakaoAuthService: KakaoAuthService())
        super.init(nibName: nil, bundle: nil)
    }

    init(viewModel: any LoginViewModelProtocol) {
        self.viewModel = viewModel as! LoginViewModel
        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        view = mainView
        let _ = viewModel.transform(input: input.eraseToAnyPublisher())
        bind()

        mainView.kakaoLoginAction = { [weak self] in
            guard let self else { return }
            input.send(.loginButtonTapped)
        }
    }

    
    private func checkAutoUpdate() {
        let popup = CheckPopupViewController(
            title: "최신 버전 업데이트",
            message: "최신 버전 업데이트를 위해 스토어로 이동합니다.",
            confirmTitle: "확인"
        )
        
        popup.onConfirmTapped = { [weak self] in
            // Input/Output 패턴 추가
        }
        
        print("check auto update")
        
        present(popup, animated: true)
    }


    // MARK: - Bind

    private func bind() {
        viewModel.navigationEvent.onboardingEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.onNeedOnboarding?()
            }
            .store(in: &cancellables)

        viewModel.navigationEvent.tabBarEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.onLoginSuccess?()
            }
            .store(in: &cancellables)

    }
}
