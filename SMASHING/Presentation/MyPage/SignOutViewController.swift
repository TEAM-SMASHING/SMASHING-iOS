//
//  SignOutViewController.swift
//  SMASHING
//
//  Created by 이승준 on 3/8/26.
//

import UIKit
import Combine

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

    /// View 이벤트 → ViewModel Input 전송
    private func bindActions() {
        signOutView.leftButtonAction = { [weak self] in
            NavigationManager.shared.pop()
        }

        signOutView.checkboxAction = { [weak self] in
            self?.inputSubject.send(.checkBoxTapped)
        }

        signOutView.signoutAction = { [weak self] in
            self?.inputSubject.send(.signoutTapped)
        }
    }

    /// ViewModel Output → UI 반영
    private func bind(output: SignOutViewModel.Output) {
        output.isButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.signOutView.configure(isSignOutEnabled: isEnabled)
            }
            .store(in: &cancellables)

        output.navToMyPage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                NavigationManager.shared.pop()
            }
            .store(in: &cancellables)
    }
}

protocol SignOutViewModelProtocol: InputOutputProtocol where Input == SignOutViewModel.Input, Output == SignOutViewModel.Output{
    
}

final class SignOutViewModel: SignOutViewModelProtocol {

    enum Input {
        case checkBoxTapped
        case signoutTapped
    }
    
    struct Output {
        let signOut = PassthroughSubject<Void, Never>()
        let isButtonEnabled = PassthroughSubject<Bool, Never>()
        let navToMyPage = PassthroughSubject<Void, Never>()
    }
    
    let output = Output()
    private var isChecked: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    
    func transform(input: AnyPublisher<Input, Never>) -> Output {
        input
            .sink { [weak self] input in
                guard let self else { return }
                switch input {
                case .checkBoxTapped:
                    self.isChecked.toggle()
                    output.isButtonEnabled.send(self.isChecked)
                case .signoutTapped:
                    output.navToMyPage.send()
                }
            }
            .store(in: &cancellables)
        return output
    }
}
