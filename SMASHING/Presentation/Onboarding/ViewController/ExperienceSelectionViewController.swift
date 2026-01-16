//
//  TierSelectionViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/17/26.
//

import Combine
import UIKit

import SnapKit
import Then

final class ExperienceSelectionViewController: BaseViewController {
    
    // MARK: - Properties
        
    let tierSelectionView = ExperienceSelectionView()
    
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
        super.viewDidLoad()
        view = tierSelectionView
        bind()
    }
    
    private func bind() {
        tierSelectionView.action = { [weak self] tier in
            guard let self else { return }
            input.send(.tierTapped(tier))
        }
    }
}
