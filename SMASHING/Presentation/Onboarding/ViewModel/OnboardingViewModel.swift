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
    var store: OnboardingObject{get}
    var output: Output {get}
}

final class OnboardingViewModel: OnboardingViewModelProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    
    var store = OnboardingObject()
    
    let onboardingUserService = UserOnboardingService()
    
    enum Input {
        case hitNext(OnboardingType)
        case hitBack(OnboardingType)
        case addressSelected(String)
        case complete
        case nicknameTyped(String)
        case genderTapped(Gender)
        case kakaoOpenChatLinkTyped(String)
        case sportsTapped(Sports)
        case experienceRangeTapped(ExperienceRange)
        case addressTapped
    }

    struct Output {
        let buttonEnabled = CurrentValueSubject<Bool, Never>(false)
        let currentStep = CurrentValueSubject<OnboardingType, Never>(.nickname)
        let dismissOnboarding: PassthroughSubject<Void, Never> = .init()
        let checkNicknameDuplicationEnabled: PassthroughSubject<Bool, Never> = .init()
        let nicknameDuplicationResult: PassthroughSubject<Bool, Never> = .init()
        let checkKakaoOpenChatLinkEnabled: PassthroughSubject<Bool, Never> = .init()
        let showMapSearchViewController: PassthroughSubject<Void, Never> = .init()
        let addressUpdated = PassthroughSubject<String, Never>()
        let navAddressPushEvent = PassthroughSubject<Void, Never>()
        let navBackToLoginEvent = PassthroughSubject<Void, Never>()
        let navPushToOnboardingCompletionEvent = PassthroughSubject<Void, Never>()
    }

    let output = Output()
    
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
                return self.onboardingUserService.checkNicknameAvailability(nickname: text)
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
                return self.onboardingUserService.validateOpenchatUrl(url: text)
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
                        output.buttonEnabled.send(store.experienceRange != nil)
                    case .tier:
                        output.buttonEnabled.send(!store.address.isEmpty)
                    case .address:
                        onboardingUserService
                            .signup(
                                request: SignupRequestDTO(
                                    kakaoId: KeychainService.get(key: Environment.kakaoId)!,
                                    nickname: store.nickname,
                                    gender: store.gender?.rawValue ?? "",
                                    openChatUrl: store.kakaoOpenChatLink,
                                    sportCode: store.sports?.rawValue ?? "",
                                    experienceRange: store.experienceRange?.rawValue ?? "",
                                    region: store.address
                                )
                            )
                            .receive(on: DispatchQueue.main)
                                .sink { completion in
                                    switch completion {
                                    case .finished:
                                        break
                                    case .failure(let error):
                                        print("회원가입 실패: \(error)")
                                    }
                                } receiveValue: { [weak self] response in
                                    guard let self else { return }
                                    _ = KeychainService
                                        .add(
                                            key: Environment.accessTokenKey,
                                            value: response.accessToken
                                        )
                                    _ = KeychainService
                                        .add(
                                            key: Environment.refreshTokenKey,
                                            value: response.refreshToken
                                        )
                                    output.navPushToOnboardingCompletionEvent.send()
                                }
                                .store(in: &cancellables)
                    }
                case .hitBack(let before):
                    output.buttonEnabled.send(false)
                    switch before {
                    case .nickname:
                        output.navBackToLoginEvent.send()
                    case .gender:
                        output.buttonEnabled.send(!store.nickname.isEmpty)
                    case .chat:
                        output.buttonEnabled.send(store.gender != nil)
                    case .sports:
                        output.buttonEnabled.send(!store.kakaoOpenChatLink.isEmpty)
                    case .tier:
                        output.buttonEnabled.send(store.sports != nil)
                    case .address:
                        output.buttonEnabled.send(store.experienceRange != nil)
                    }
                    break
                case .complete:
                    output.navPushToOnboardingCompletionEvent.send()
                    break
                case .genderTapped(let gender):
                    store.gender = gender
                    output.buttonEnabled.send(true)
                case .sportsTapped(let sports):
                    store.sports = sports
                    output.buttonEnabled.send(true)
                case .experienceRangeTapped(let experienceRange):
                    store.experienceRange = experienceRange
                    output.buttonEnabled.send(true)
                case .addressTapped:
                    output.navAddressPushEvent.send()
                case .addressSelected(let address):
                    store.address = address.replacingOccurrences(of: "서울 ", with: "")
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
    var experienceRange: ExperienceRange? = nil
    var address: String = ""
}
