//
//  LoginViewModel.swift
//  SMASHING
//
//  Created by 이승준 on 1/16/26.
//

import Combine

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
        input
        .sink { [weak self] input in
            guard let self else { return }
            switch input {
            case .loginButtonTapped:
                kakaoAuthService.login()
                    .sink { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            print("로그인 중 에러 발생: \(error)")
                        }
                    } receiveValue: { [weak self] loginResult in
                        guard let self else { return }
                        switch loginResult {
                        case .needSignUp(let userId):
                            _ = KeychainService.add(key: Environment.userIdKey, value: userId)
                            self.navigationEvent.onboardingEvent.send()
                        case .success(let accessToken, let refreshToken, let userId):
                            _ = KeychainService.add(key: Environment.userIdKey, value: userId)
                            _ = KeychainService.add(key: Environment.accessTokenKey, value: accessToken)
                            _ = KeychainService.add(key: Environment.refreshTokenKey, value: refreshToken)
                            self.navigationEvent.tabBarEvent.send()
                        }
                    }
                    .store(in: &cancellables)
            }
        }
        .store(in: &cancellables)
        return output
    }
}
