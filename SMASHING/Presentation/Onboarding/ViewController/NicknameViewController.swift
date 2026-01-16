//
//  NicknameViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/9/26.
//

import Combine
import UIKit

import SnapKit
import Then

final class NicknameViewController: BaseViewController {
    
    // MARK: - Properties
    
    let nicknameView = NicknameView()
    
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
        view = nicknameView
        bind()
    }
    
    // MARK: - Public Methods
    
    private func bind() {
        nicknameView.nicknameTextField
            .textDidChangePublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self else { return }
                input.send(.nicknameTyped(text))
            }
            .store(in: &cancellables)
            
    }
}
