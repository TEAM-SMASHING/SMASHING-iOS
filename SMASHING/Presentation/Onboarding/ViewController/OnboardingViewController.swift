//
//  OnboardingView.swift
//  SMASHING
//
//  Created by 이승준 on 1/7/26.
//

import UIKit

import SnapKit
import Then

enum OnboardingType: Int, CaseIterable {
    case nickname, gender, chat, sports, tier, area
    
    var mainTitle: String {
        switch self {
        case .nickname:
            "사용하실 닉네임을 입력해주세요"
        case .gender:
            "성별을 선택해주세요"
        case .chat:
            "카카오톡 오픈채팅 링크를 입력해주세요"
        case .sports:
            "주 스포츠 1개를 선택해주세요"
        case .tier:
            "실력을 설정해주세요"
        case .area:
            "활동 지역을 설정해주세요"
        }
    }
    
    var subTitle: String {
        switch self {
        case .nickname:
            "특수문자를 제외한 한글, 영어, 숫자만 가능해요"
        case .gender:
            "매칭 시 성별을 보여드리기 위함이에요"
        case .chat:
            "매칭 시 상대방에게 공개돼요"
        case .sports:
            "회원가입 이후 스포츠 종목을 더 추가할 수 있어요"
        case .tier:
            "구력을 통해 임시 티어가 결정돼요!"
        case .area:
            "서울 소재 주소만 입력가능해요"
        }
    }
}

final class OnboardingViewController: BaseViewController {

    // MARK: - Properties

    private let containerView = OnboardingContainerView()
    private var currentStep: OnboardingType = .nickname

    private var viewModel: OnboardingViewModelProtocol
    private var input = PassthroughSubject<OnboardingViewModel.Input, Never>()
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Life Cycle

    init(viewModel: OnboardingViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        self.view = containerView
        setupActions()
        showStep(.nickname)
        bind()
    }

    private func setupActions() {
        containerView.navigationBar.setLeftButton { [weak self] in
            guard let self else { return }
            input.send(.hitBack)
        }
        
        containerView.nextAction = { [weak self] in
            guard let self else { return }
            input.send(.hitNext)
            nextButtonTapped()
        }
    }

    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
    }
    
    // MARK: - Actions
    
    @objc private func nextButtonTapped() {
        let nextIndex = currentStep.rawValue + 1
        if nextIndex < OnboardingType.allCases.count {
            guard let nextStep = OnboardingType(rawValue: nextIndex) else { return }
            currentStep = nextStep
            showStep(currentStep)
        } else {
            finishOnboarding()
        }
    }
    
    // MARK: - Private Methods
    
    private func backButtonTapped() {
        let beforeIndex = currentStep.rawValue - 1
        if beforeIndex > -1 {
            guard let nextStep = OnboardingType(rawValue: beforeIndex) else { return }
            currentStep = nextStep
            showStep(currentStep)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func showStep(_ step: OnboardingType) {
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        
        containerView.mainTitleLabel.text = step.mainTitle
        containerView.subTitleLabel.text = step.subTitle
        
        let totalSteps = Float(OnboardingType.allCases.count)
        let currentProgress = Float(step.rawValue + 1) / totalSteps
        containerView.progressBar.setProgress(currentProgress, animated: true)
        
        let nextVC = makeChildViewController(for: step)
        addChild(nextVC)
        containerView.containerView.addSubview(nextVC.view)
        
        nextVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        nextVC.didMove(toParent: self)
        
        let buttonTitle = (step == OnboardingType.allCases.last) ? "완료" : "다음"
        containerView.nextButton.setTitle(buttonTitle, for: .normal)
    }
    
    private func makeChildViewController(for step: OnboardingType) -> UIViewController {
        switch step {
        case .nickname: return NicknameViewController(viewModel: viewModel, input: input)
        case .gender:   return GenderViewController(viewModel: viewModel, input: input)
        case .chat:     return OpenChatCheckViewController()
        case .sports:   return SportsSelectionViewController()
        case .tier:     return TierSelectionViewController()
        case .area:     return AreaSelectionViewController()
        }
    }
    
    private func finishOnboarding() {
        print("온보딩 프로세스 완료")
    }
}

import Combine

protocol OnboardingViewModelProtocol: InputOutputProtocol where Input == OnboardingViewModel.Input,
                    Output == OnboardingViewModel.Output {
    associatedtype NavigationEvent
    var store: OnboardingObject{get}
}

final class OnboardingViewModel: OnboardingViewModelProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    
    var store = OnboardingObject()
    
    enum Input {
        case hitNext // buttonEnabled.send(false) -> 만약 데이터 있으면 : buttonEnabled.send(true)
        case hitBack
        
        case complete
        
        case nicknameTyped(String) // N/10, 중복확인 버튼 활성화
        case checkNicknameDuplication(String) // 이 String이 true면, 저장하기
        
        case genderTapped(Gender) // 저장하기
        case kakaoOpenChatLinkTyped(String) // 버튼 비활성화!! & Debouncing -> 결과에 따라
        case sportsTapped(Sports) // 저장하기
        case tierTapped(Tier) // 저장하기
        case areaTapped // 뷰 띄우기
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
    }
    
    struct NavigationEvent {
        
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
            .sink { [weak self] text in
                guard let self = self else { return }
                // 검색 API 호출
                print(text)
            }
            .store(in: &cancellables)
        
        input
            .compactMap { input -> String? in
                guard case let .kakaoOpenChatLinkTyped(text) = input else { return nil }
                return text
            }
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self = self else { return }
                print(text)
                // 카카오 오픈채팅 유효성 검사 API 연동
            }
            .store(in: &cancellables)

        input
            .sink { [weak self] input in
                guard let self = self else { return }
                switch input {
                case .hitNext:
                    // 다음 페이지 개산해서 반환
                    // ViewModel을 주입하고 store를 확인한다.
                    // store의 값으로 뷰를 그린다.
                    // 값이 있으면, buttonEnabled.send(true)
                    // 값이 없으면, buttonEnabled.send(false)
                    return
                case .hitBack:
                                        print("Hit Back")
                case .complete:
                    // 주소 View에서 호출하면 됨
                    // API 호출
                    // 결과에 따라, switch -> main
                    return
                case .checkNicknameDuplication(let string):
                    // API 호출
                    return
                case .genderTapped(let gender):
                    print(gender)
                    store.gender = gender
                    output.buttonEnabled.send(true)
                case .sportsTapped(let sports):
                    print(sports)
                    store.sports = sports
                    output.buttonEnabled.send(true)
                case .tierTapped(let tier):
                    store.tier = tier
                    output.buttonEnabled.send(true)
                case .areaTapped:
                    return
                default :
                    return
                }
            }
            .store(in: &cancellables)
        return output
    }
}

final class OnboardingObject {
    var nickname: String = ""
    var gender: Gender? = nil
    var kakaoOpenChatLink: String? = nil
    var sports: Sports? = nil
    var tier: Tier? = nil
}
