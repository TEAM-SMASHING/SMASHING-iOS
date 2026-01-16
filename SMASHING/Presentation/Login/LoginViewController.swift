//
//  LoginViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/12/26.
//

import Combine
import UIKit

final class LoginViewController: BaseViewController {
    
    private let viewModel: any LoginViewModelProtocol
    private let mainView = LoginView()
    private let input = PassthroughSubject<LoginViewModel.Input, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: any LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view = mainView
        let _ = viewModel.transform(input: input.eraseToAnyPublisher())
        
        mainView.kakaoLoginAction = { [weak self] in
            guard let self else { return }
            input.send(.loginButtonTapped)
        }
    }
}
