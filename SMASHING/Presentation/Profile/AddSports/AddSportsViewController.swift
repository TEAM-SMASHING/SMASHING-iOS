//
//  AddSportsViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

import UIKit
import Combine

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
    private let viewModel: AddSportsViewModelProtocol
    private let inputSubject = PassthroughSubject<AddSportsViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
        
    init(viewModel: AddSportsViewModelProtocol = AddSportsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = containerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        bind()
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
        case .sportsSelection:
            let controller = EditSportsSelectionViewController()
            controller.onSportSelected = { [weak self] sport in
                self?.inputSubject.send(.sportSelected(sport))
            }
            return controller
        case .tierSelection:
            let controller = EditTierSelectionViewController()
            controller.onExperienceSelected = { [weak self] experience in
                self?.inputSubject.send(.experienceSelected(experience))
            }
            return controller
        }
    }
    
    private func finishOnboarding() {
        inputSubject.send(.submit)
    }

    private func bind() {
        let output = viewModel.transform(input: inputSubject.eraseToAnyPublisher())
        
        output.isLoading
            .receive(on: DispatchQueue.main)
            .sink { _ in }
            .store(in: &cancellables)
        
        output.submitCompleted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        output.errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.showErrorAlert(message: message)
            }
            .store(in: &cancellables)
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
