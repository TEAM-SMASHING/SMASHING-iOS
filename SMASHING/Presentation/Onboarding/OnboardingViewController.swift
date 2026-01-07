//
//  OnboardingView.swift
//  SMASHING
//
//  Created by 이승준 on 1/7/26.
//

import UIKit

import SnapKit
import Then

class OnboardingViewController: BaseViewController {
    
    enum TransitionDirection {
        case forward  // 다음 단계로 (오른쪽 -> 왼쪽 슬라이드)
        case backward // 이전 단계로 (왼쪽 -> 오른쪽 슬라이드)
    }
    
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
    
    private lazy var navigationBar = CustomNavigationBar(title: "", leftAction: { [weak self] in
        // 추후에 Coordinator로 전환하기
        self?.backButtonTapped()
    })
    
    private let progressBar = UIProgressView().then {
        $0.tintColor = .State.progressFill
        $0.backgroundColor = .State.progressTrack
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }
    
    private let mainTitleLabel = UILabel().then {
        $0.font = .pretendard(.titleXlSb)
        $0.textColor = .Text.primary
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = .pretendard(.textMdM)
        $0.textColor = .Text.tertiary
    }
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .Background.canvas
    }
    private let nextButton = CTAButton(label: "다음")
    
    private var currentStep: OnboardingType = .nickname
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .Background.canvas
        
        showStep(.nickname)
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    override func setUI() {
        self.view.addSubviews(
            navigationBar, progressBar,
            mainTitleLabel, subTitleLabel,
            containerView, nextButton)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(self.view.safeAreaLayoutGuide)
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
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(4) // 적절한 간격 추가 가능
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        containerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(subTitleLabel.snp.bottom)
            $0.bottom.equalTo(nextButton.snp.top)
        }
    }
    
    @objc private func nextButtonTapped() {
        let nextIndex = currentStep.rawValue + 1
        if nextIndex < OnboardingType.allCases.count {
            guard let nextStep = OnboardingType(rawValue: nextIndex) else { return }
            currentStep = nextStep
            // 방향을 .forward로 전달
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
            // 방향을 .backward로 전달
            showStep(currentStep, direction: .backward)
        } else {
            // 로그인 화면 등으로 이동 로직
        }
    }
    
    func showStep(_ step: OnboardingType, direction: TransitionDirection = .forward) {
        mainTitleLabel.text = step.mainTitle
        subTitleLabel.text = step.subTitle
        
        let totalSteps = Float(OnboardingType.allCases.count)
        let currentProgress = Float(step.rawValue + 1) / totalSteps
        self.progressBar.setProgress(currentProgress, animated: true)
        
        let nextVC = makeChildViewController(for: step)
        transition(to: nextVC, direction: direction)
        
        let buttonTitle = (step == OnboardingType.allCases.last) ? "완료" : "다음"
        nextButton.setTitle(buttonTitle, for: .normal)
    }
    
    private func transition(to nextVC: UIViewController, direction: TransitionDirection) {
        let previousVC = children.first
        
        addChild(nextVC)
        containerView.addSubview(nextVC.view)
        
        nextVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = (direction == .forward) ? .fromRight : .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        containerView.layer.add(transition, forKey: kCATransition)
        
        previousVC?.willMove(toParent: nil)
        previousVC?.view.removeFromSuperview()
        previousVC?.removeFromParent()
        
        nextVC.didMove(toParent: self)
    }
    
    private func finishOnboarding() {
        print("온보딩 완료 - 메인 화면으로 전환합니다.")
        // 예: 상위 Coordinator에 알리거나 루트 뷰 컨트롤러 교체
        // self.navigationController?.pushViewController(MainViewController(), animated: true)
    }
    
    private func makeChildViewController(for step: OnboardingType) -> UIViewController {
        switch step {
        default:
            let vc = UIViewController()
            vc.view.backgroundColor = step.background
            return vc
        }
    }
    
}
