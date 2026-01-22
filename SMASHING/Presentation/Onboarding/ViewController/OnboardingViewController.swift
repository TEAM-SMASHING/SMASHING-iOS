//
//  OnboardingView.swift
//  SMASHING
//
//  Created by 이승준 on 1/7/26.
//

import Combine
import UIKit

import SnapKit
import Then

enum OnboardingType: Int, CaseIterable {
    case nickname, gender, chat, sports, tier, address
    
    var mainTitle: String {
        switch self {
        case .nickname:
            "닉네임을 입력해주세요"
        case .gender:
            "성별을 선택해주세요"
        case .chat:
            "카카오톡 오픈채팅 링크를 입력해주세요"
        case .sports:
            "종목을 선택해주세요"
        case .tier:
            "구력을 선택해주세요"
        case .address:
            "활동 지역을 설정해주세요"
        }
    }
    
    var subTitle: String {
        switch self {
        case .nickname:
            "한글, 영어, 숫자만 가능해요"
        case .gender:
            " "
        case .chat:
            "매칭이 확정되면 상대방이 확인할 수 있어요"
        case .sports:
            "회원가입 이후 종목을 추가할 수 있어요"
        case .tier:
            "구력을 통해 임시 티어가 결정돼요"
        case .address:
            "서울 소재 주소만 입력 가능해요"
        }
    }
}

final class OnboardingViewController: BaseViewController {
    
    // MARK: - Properties
    
    var backAction: (() -> Void)?

    // MARK: - Properties

    private let containerView = OnboardingContainerView()
    private var currentStep: OnboardingType = .nickname

    private var viewModel: any OnboardingViewModelProtocol
    private var input = PassthroughSubject<OnboardingViewModel.Input, Never>()
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Life Cycle

    init(viewModel: any OnboardingViewModelProtocol) {
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
            input.send(.hitBack(currentStep))
            backButtonTapped()
        }
        
        containerView.nextAction = { [weak self] in
            guard let self else { return }
            input.send(.hitNext(currentStep))
            nextButtonTapped()
        }
    }

    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output.buttonEnabled
            .sink { [weak self] bool in
                guard let self else { return }
                containerView.nextButton.isEnabled = bool
            }
            .store(in: &cancellables)
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
            backAction?()
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
        case .chat:     return OpenChatCheckViewController(viewModel: viewModel, input: input)
        case .sports:   return SportsSelectionViewController(viewModel: viewModel, input: input)
        case .tier:     return ExperienceSelectionViewController(viewModel: viewModel, input: input)
        case .address:  return AreaSelectionViewController(viewModel: viewModel, input: input)
        }
    }
    
    private func finishOnboarding() {
        print("온보딩 프로세스 완료")
    }
    
    func updateSelectedAddress(_ address: String) {
        self.input.send(.addressSelected(address))
        if currentStep == .address {
            updateAddressUI(address)
        }
    }
    
    private func updateAddressUI(_ address: String) {
        if let areaVC = children.first(where: { $0 is AreaSelectionViewController }) as? AreaSelectionViewController {
            (areaVC.view as? AreaSelectionView)?.updateAddress(address: address)
        }
    }
}
