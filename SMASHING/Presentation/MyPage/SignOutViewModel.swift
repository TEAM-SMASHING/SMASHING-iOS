//
//  SignOutViewModel.swift
//  SMASHING
//
//  Created by 이승준 on 3/18/26.
//

import Combine

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
