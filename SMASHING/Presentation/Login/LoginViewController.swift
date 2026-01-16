//
//  LoginViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/12/26.
//

import Combine
import UIKit

final class LoginViewController: BaseViewController {
    
    private let viewModel: any LoginViewModelProtocol
    private let mainView = LoginView()
    private let input = PassthroughSubject<LoginViewModel.Input, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: any LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view = mainView
        let _ = viewModel.transform(input: input.eraseToAnyPublisher())
        
        mainView.kakaoLoginAction = { [weak self] in
            guard let self else { return }
            input.send(.loginButtonTapped)
        }
    }
}

import Combine

protocol InputOutputProtocol: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(input: AnyPublisher<Input, Never>) -> Output
}

protocol LoginViewModelProtocol: InputOutputProtocol where Input == LoginViewModel.Input, Output == LoginViewModel.Output {
    associatedtype NavigationEvent
}

final class LoginViewModel: LoginViewModelProtocol {
    
    // MARK: - Type
    
    enum Input {
        case loginButtonTapped
    }

    struct Output { }
    
    struct NavigationEvent {
        let onboardingEvent = PassthroughSubject<Void, Never>()
        let tabBarEvent = PassthroughSubject<Void, Never>()
    }
    
    // MARK: - Properties

    let navigationEvent = NavigationEvent()
    private let output = Output()
    private var kakaoAuthService: KakaoAuthServiceProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    
    init(kakaoAuthService: KakaoAuthServiceProtocol) {
        self.kakaoAuthService = kakaoAuthService
    }
    
    // MARK: - Public Methods
    
    func transform(input: AnyPublisher<Input, Never>) -> Output {
        kakaoAuthService.login()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("로그인 중 에러 발생: \(error)")
                }
            } receiveValue: { loginResult in
                switch loginResult {
                case .needSignUp(let authId):
                    self.navigationEvent.onboardingEvent.send()
                case .success(let accessToken, let refreshToken, let authId):
                    self.navigationEvent.tabBarEvent.send()
                }
            }
            .store(in: &cancellables)
        return output
    }
}
