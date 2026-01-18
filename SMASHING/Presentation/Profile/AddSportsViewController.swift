//
//  AddSportsViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

import UIKit

import SnapKit

enum AddSportsType: Int, CaseIterable {
    case sportsSelection, tierSelection
    
    var mainTitle: String {
        switch self {
            case .sportsSelection: return "추가할 스포츠를 선택해주세요"
            case .tierSelection: return "실력을 설정해주세요"
        }
    }
    
    var subTitle: String {
        switch self {
            case .sportsSelection: return " "
            case .tierSelection: return "구력을 통해 임시 티어가 결정돼요"
        }
    }
}

class AddSportsViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let containerView = OnboardingContainerView()
    private var currentStep: AddSportsType = .sportsSelection
    
    // MARK: - Life Cycle
        
    override func loadView() {
        self.view = containerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        showStep(currentStep)
    }
    
    private func setupActions() {
        containerView.navigationBar.setLeftButton { [weak self] in
            self?.backButtonTapped()
        }
        
        containerView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func nextButtonTapped() {
        let nextIndex = currentStep.rawValue + 1
        if nextIndex < AddSportsType.allCases.count {
            guard let nextStep = AddSportsType(rawValue: nextIndex) else { return }
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
            guard let nextStep = AddSportsType(rawValue: beforeIndex) else { return }
            currentStep = nextStep
            showStep(currentStep)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func showStep(_ step: AddSportsType) {
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        
        containerView.mainTitleLabel.text = step.mainTitle
        containerView.subTitleLabel.text = step.subTitle
        
        let totalSteps = Float(AddSportsType.allCases.count)
        let currentProgress = Float(step.rawValue + 1) / totalSteps
        containerView.progressBar.setProgress(currentProgress, animated: true)
        
        let nextVC = makeChildViewController(for: step)
        addChild(nextVC)
        containerView.containerView.addSubview(nextVC.view)
        
        nextVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        nextVC.didMove(toParent: self)
        
        let buttonTitle = (step == AddSportsType.allCases.last) ? "완료" : "다음"
        containerView.nextButton.setTitle(buttonTitle, for: .normal)
    }
    
    private func makeChildViewController(for step: AddSportsType) -> UIViewController {
        switch step {
        case .sportsSelection: return EditSportsSelectionViewController()
        case .tierSelection: return EditTierSelectionViewController()
        }
    }
    
    private func finishOnboarding() {
        print("온보딩 프로세스 완료")
    }
}
