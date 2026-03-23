//
//  SignOutViewController.swift
//  SMASHING
//
//  Created by 이승준 on 3/8/26.
//

import Combine
import UIKit

final class SignOutViewController: BaseViewController {
    
    let signOutView = SignOutView()
    let viewModel = SignOutViewModel()
    private let inputSubject = PassthroughSubject<SignOutViewModel.Input, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        view = signOutView
        bindActions()
        bind(output: viewModel.transform(input: inputSubject.eraseToAnyPublisher()))
    }
    
    private func bindActions() {
        signOutView.leftButtonAction = {
            NavigationManager.shared.pop()
        }
        
        signOutView.checkboxAction = { [weak self] in
            self?.inputSubject.send(.checkBoxTapped)
        }
        
        signOutView.signoutAction = { [weak self] in
            self?.inputSubject.send(.signoutTapped)
        }
    }
    
    private func bind(output: SignOutViewModel.Output) {
        output.isButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.signOutView.configure(isSignOutEnabled: isEnabled)
            }
            .store(in: &cancellables)
        
        output.navToMyPage
            .receive(on: DispatchQueue.main)
            .sink {
                NavigationManager.shared.pop()
            }
            .store(in: &cancellables)
    }
}
