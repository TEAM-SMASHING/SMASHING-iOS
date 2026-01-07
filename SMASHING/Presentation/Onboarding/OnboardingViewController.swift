//
//  OnboardingView.swift
//  SMASHING
//
//  Created by 이승준 on 1/7/26.
//

import UIKit

import SnapKit
import Then

class OnboardingContainerView: UIView {
    
    // MARK: - UI Components
    let navigationBar = CustomNavigationBar(title: "", leftAction: nil)
    
    let progressBar = UIProgressView().then {
        $0.tintColor = .State.progressFill
        $0.backgroundColor = .State.progressTrack
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }
    
    let mainTitleLabel = UILabel().then {
        $0.font = .pretendard(.titleXlSb)
        $0.textColor = .Text.primary
    }
    
    let subTitleLabel = UILabel().then {
        $0.font = .pretendard(.textMdM)
        $0.textColor = .Text.tertiary
    }
    
    let containerView = UIView().then {
        $0.backgroundColor = .Background.canvas
    }
    
    let nextButton = CTAButton(label: "다음")
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .Background.canvas
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        addSubviews(
            navigationBar, progressBar,
            mainTitleLabel, subTitleLabel,
            containerView, nextButton
        )
    }
    
    private func setupLayout() {
        navigationBar.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(safeAreaLayoutGuide)
        }
        
        progressBar.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.height.equalTo(8)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(progressBar.snp.bottom).offset(16)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(4)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        containerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(subTitleLabel.snp.bottom)
            $0.bottom.equalTo(nextButton.snp.top)
        }
    }
}

class OnboardingViewController: BaseViewController {
    
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
                "배드민턴의 실력을 설정해주세요"
            case .area:
                "활동 지역을 설정해주세요"
            }
        }
        
        var subTitle: String {
            switch self {
            case .nickname:
                "특수문자를 제외한 한글, 영어, 숫자만 가능해요 "
            case .gender:
                "매칭 시 성별을 보여드리기 위함이에요"
            case .chat:
                "매칭 시 상대방에게 공개돼요"
            case .sports:
                "회원가입 이후 스포츠 종목을 더 추가할 수 있어요"
            case .tier:
                "구력을 통해 임시 티어가 결정돼요!"
            case .area:
                "설정한 지역 내에서 라이벌을 찾아드려요"
            }
        }
        
        var background: UIColor {
            switch self {
            case .nickname:
                    .systemRed
            case .gender:
                    .systemOrange
            case .chat:
                    .systemYellow
            case .sports:
                    .systemGreen
            case .tier:
                    .systemBlue
            case .area:
                    .systemPurple
            }
        }
    }
    
    // MARK: - Properties
    
    private let rootView = OnboardingContainerView()
    private var currentStep: OnboardingType = .nickname
    
    enum TransitionDirection {
        case forward, backward
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .Background.canvas
        setupActions()
        showStep(.nickname)
    }
    
    private func setupActions() {
        rootView.navigationBar.setLeftButton { [weak self] in
            self?.backButtonTapped()
        }
        
        rootView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Logic
    @objc private func nextButtonTapped() {
        let nextIndex = currentStep.rawValue + 1
        if nextIndex < OnboardingType.allCases.count {
            guard let nextStep = OnboardingType(rawValue: nextIndex) else { return }
            currentStep = nextStep
            showStep(currentStep, direction: .forward)
        } else {
            finishOnboarding()
        }
    }
    
    private func backButtonTapped() {
        let beforeIndex = currentStep.rawValue - 1
        if beforeIndex > -1 {
            guard let nextStep = OnboardingType(rawValue: beforeIndex) else { return }
            currentStep = nextStep
            showStep(currentStep, direction: .backward)
        } else {
            // 로그인 화면으로 pop 혹은 dismiss 처리
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showStep(_ step: OnboardingType, direction: TransitionDirection = .forward) {
        // 1. UI 상태 업데이트 (View에 직접 접근)
        rootView.mainTitleLabel.text = step.mainTitle
        rootView.subTitleLabel.text = step.subTitle
        
        let totalSteps = Float(OnboardingType.allCases.count)
        let currentProgress = Float(step.rawValue + 1) / totalSteps
        rootView.progressBar.setProgress(currentProgress, animated: true)
        
        // 2. 새로운 Child VC 생성 및 전환
        let nextVC = makeChildViewController(for: step)
        transition(to: nextVC, direction: direction)
        
        // 3. 버튼 타이틀 변경
        let buttonTitle = (step == OnboardingType.allCases.last) ? "완료" : "다음"
        rootView.nextButton.setTitle(buttonTitle, for: .normal)
    }
    
    private func transition(to nextVC: UIViewController, direction: TransitionDirection) {
        let previousVC = children.first
        
        addChild(nextVC)
        rootView.containerView.addSubview(nextVC.view)
        
        nextVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = (direction == .forward) ? .fromRight : .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        rootView.containerView.layer.add(transition, forKey: kCATransition)
        
        previousVC?.willMove(toParent: nil)
        previousVC?.view.removeFromSuperview()
        previousVC?.removeFromParent()
        
        nextVC.didMove(toParent: self)
    }
    
    private func makeChildViewController(for step: OnboardingType) -> UIViewController {
        // 실제 구현 시 각 단계에 맞는 VC 반환
        let vc = UIViewController()
        vc.view.backgroundColor = step.background
        return vc
    }
    
    private func finishOnboarding() {
        print("온보딩 프로세스 완료")
    }
}
