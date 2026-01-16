//
//  GenderViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/9/26.
//

import Combine
import UIKit

import SnapKit
import Then

final class GenderViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let genderView = GenderView()
    
    private var viewModel: any OnboardingViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []
    private let input: PassthroughSubject<OnboardingViewModel.Input, Never>
    
    // MARK: - Init
    
    init(viewModel: any OnboardingViewModelProtocol,
         input: PassthroughSubject<OnboardingViewModel.Input, Never>) {
        self.viewModel = viewModel
        self.input = input
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        view = genderView
        bind()
    }
    
    private func bind() {
        genderView.action = { [weak self] gender in
            guard let self else { return }
            input.send(.genderTapped(gender))
        }
    }
    
    // MARK: - Setup Methods
    
    func configure(action: @escaping (Gender) -> Void) {
        genderView.configure(action: action)
    }
}
