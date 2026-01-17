//
//  OnboardingViewModel.swift
//  SMASHING
//
//  Created by 이승준 on 1/17/26.
//

import Combine
import Foundation

protocol OnboardingViewModelProtocol: InputOutputProtocol where Input == OnboardingViewModel.Input,
                    Output == OnboardingViewModel.Output {
    associatedtype NavigationEvent
    var store: OnboardingObject{get}
    var output: Output {get}
}

final class OnboardingViewModel: OnboardingViewModelProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    
    var store = OnboardingObject()
    
    let userService = UserService()
    
    enum Input {
        case hitNext(OnboardingType) // buttonEnabled.send(false) -> 만약 데이터 있으면 : buttonEnabled.send(true)
        case hitBack(OnboardingType)
        
        case addressSelected(String)
        
        case complete
        
        case nicknameTyped(String)
        
        case genderTapped(Gender) // 저장하기
        case kakaoOpenChatLinkTyped(String) // 버튼 비활성화!! & Debouncing -> 결과에 따라
        case sportsTapped(Sports) // 저장하기
        case tierTapped(SportsExperienceType) // 저장하기
        case addressTapped // 뷰 띄우기
    }

    struct Output {
        let buttonEnabled = CurrentValueSubject<Bool, Never>(false)
        
        let currentStep = CurrentValueSubject<OnboardingType, Never>(.nickname)
        // 처음 / 진행 / 마지막 나누어서 각각 동작이 달라질 수 있다.
        
        let dismissOnboarding: PassthroughSubject<Void, Never> = .init()
        // 마지막이어서 가입 API 호출
        
        let checkNicknameDuplicationEnabled: PassthroughSubject<Bool, Never> = .init()
        // 1 글자라도 있으면
        
        let nicknameDuplicationResult: PassthroughSubject<Bool, Never> = .init()
        //
        
        let checkKakaoOpenChatLinkEnabled: PassthroughSubject<Bool, Never> = .init()
        // 가능하면 저장하기
        
        let showMapSearchViewController: PassthroughSubject<Void, Never> = .init()
        // Coordinator Pattern 쓰면 되는거 아님?
        let addressUpdated = PassthroughSubject<String, Never>()
    }
    
    struct NavigationEvent {
        let addressPushEvent = PassthroughSubject<Void, Never>()
        let backToLoginEvent = PassthroughSubject<Void, Never>()
        let pushToOnboardingCompletionEvent = PassthroughSubject<Void, Never>()
    }

    var output = Output()
    let navigationEvent = NavigationEvent()
    
    func transform(input: AnyPublisher<Input, Never>) -> Output {
        
        input
            .compactMap { input -> String? in
                guard case let .nicknameTyped(text) = input else { return nil }
                return text
            }
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { [weak self] text -> AnyPublisher<Bool, Never> in
                guard let self = self, !text.isEmpty else {
                    return Just(false).eraseToAnyPublisher()
                }
                return self.userService.checkNicknameAvailability(nickname: text)
                    .replaceError(with: false)
                    .eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] isAvailable in
                guard let self = self else { return }
                output.buttonEnabled.send(isAvailable)
                output.checkNicknameDuplicationEnabled.send(isAvailable)
            }
            .store(in: &cancellables)
        
        input
            .compactMap { input -> String? in
                guard case let .kakaoOpenChatLinkTyped(text) = input else { return nil }
                return text
            }
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { [weak self] text -> AnyPublisher<Bool, Never> in
                guard let self = self, !text.isEmpty else {
                    return Just(false).eraseToAnyPublisher()
                }
                return self.userService.validateOpenchatUrl(url: text)
                    .replaceError(with: false)
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAvailable in
                guard let self = self else { return }
                output.buttonEnabled.send(isAvailable)
                output.checkKakaoOpenChatLinkEnabled.send(isAvailable)
            }
            .store(in: &cancellables)

        input
            .sink { [weak self] input in
                guard let self = self else { return }
                switch input {
                case .hitNext(let before):
                    output.buttonEnabled.send(false)
                    switch before {
                    case .nickname:
                        output.buttonEnabled.send(!store.nickname.isEmpty)
                    case .gender:
                        output.buttonEnabled.send(!store.kakaoOpenChatLink.isEmpty)
                    case .chat:
                        output.buttonEnabled.send(store.sports != nil)
                    case .sports:
                        output.buttonEnabled.send(store.tier != nil)
                    case .tier:
                        output.buttonEnabled.send(!store.address.isEmpty)
                    case .address:
                        navigationEvent.pushToOnboardingCompletionEvent.send()
                    }
                case .hitBack(let before):
                    output.buttonEnabled.send(false)
                    switch before {
                    case .nickname:
                        navigationEvent.backToLoginEvent.send()
                    case .gender:
                        output.buttonEnabled.send(!store.nickname.isEmpty)
                    case .chat:
                        output.buttonEnabled.send(store.gender != nil)
                    case .sports:
                        output.buttonEnabled.send(!store.kakaoOpenChatLink.isEmpty)
                    case .tier:
                        output.buttonEnabled.send(store.sports != nil)
                    case .address:
                        output.buttonEnabled.send(store.tier != nil)
                    }
                    break
                case .complete:
                    navigationEvent.pushToOnboardingCompletionEvent.send()
                    break
                case .genderTapped(let gender):
                    store.gender = gender
                    output.buttonEnabled.send(true)
                case .sportsTapped(let sports):
                    store.sports = sports
                    output.buttonEnabled.send(true)
                case .tierTapped(let tier):
                    store.tier = tier
                    output.buttonEnabled.send(true)
                case .addressTapped:
                    navigationEvent.addressPushEvent.send()
                case .addressSelected(let address):
                    store.address = address
                    output.buttonEnabled.send(true)
                default :
                    break
                }
            }
            .store(in: &cancellables)
        return output
    }
}

final class OnboardingObject {
    var nickname: String = ""
    var gender: Gender? = nil
    var kakaoOpenChatLink: String = ""
    var sports: Sports? = nil
    var tier: SportsExperienceType? = nil
    var address: String = ""
}
