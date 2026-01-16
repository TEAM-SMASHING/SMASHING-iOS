//
//  SportsSelectionViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/9/26.
//

import Combine
import UIKit

import SnapKit
import Then

final class SportsSelectionViewController: BaseViewController {
    
    // MARK: - Properties
        
    let sportsView = SportsSelectionView()
    
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
        view = sportsView
        bind()
    }
    
    private func bind() {
        sportsView.action = { [weak self] sports in
            guard let self else { return }
            input.send(.sportsTapped(sports))
        }
    }
}
