//
//  SignOutViewModel.swift
//  SMASHING
//
//  Created by 이승준 on 3/18/26.
//

import Combine
import Foundation

protocol SignOutViewModelProtocol: InputOutputProtocol where Input == SignOutViewModel.Input, Output == SignOutViewModel.Output{

}

final class SignOutViewModel: SignOutViewModelProtocol {

    enum Input {
        case checkBoxTapped
        case signoutTapped      // 탈퇴 버튼 탭 → VC에서 주의 팝업 표시
        case signoutConfirmed   // 팝업 확인 후 → API 호출
    }

    struct Output {
        let isButtonEnabled = PassthroughSubject<Bool, Never>()
        let showConfirmPopup = PassthroughSubject<Void, Never>()    // 주의 팝업 트리거
        let signOutSuccess = PassthroughSubject<Void, Never>()      // 탈퇴 완료 → 로그인 이동
        let error = PassthroughSubject<NetworkError, Never>()       // 탈퇴 실패
    }

    let output = Output()
    private var isChecked: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    private let accountService = UserAccountService()

    func transform(input: AnyPublisher<Input, Never>) -> Output {
        input
            .sink { [weak self] input in
                guard let self else { return }
                switch input {
                case .checkBoxTapped:
                    self.isChecked.toggle()
                    output.isButtonEnabled.send(self.isChecked)
                case .signoutTapped:
                    output.showConfirmPopup.send()
                case .signoutConfirmed:
                    self.callWithdrawAPI()
                }
            }
            .store(in: &cancellables)
        return output
    }

    private func callWithdrawAPI() {
        accountService.withdraw()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                if case .failure(let error) = completion {
                    output.error.send(error)
                }
            } receiveValue: { [weak self] in
                self?.output.signOutSuccess.send()
            }
            .store(in: &cancellables)
    }
}
