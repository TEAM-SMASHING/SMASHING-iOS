//
//  AddressCoordinator.swift
//  SMASHING
//
//  Created by 이승준 on 1/18/26.
//

import Combine
import UIKit

final class AddressCoordinator: Coordinator {

    enum SelectionMode {
            case onboarding      // 선택만 전달 (회원가입은 나중)
            case changeRegion    // 선택 즉시 반영(보통 pop)
        }

        private let mode: SelectionMode

        // 온보딩에서 사용: 주소만 전달
        var onAddressSelectedForOnboarding: ((String) -> Void)?

        // 홈에서 사용: 주소 선택 즉시 반영 트리거
        var onAddressSelectedForRegionChange: ((String) -> Void)?
    
    var backAction: ((String) -> Void)?

    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController

    var cancellables: Set<AnyCancellable> = []

    init(navigationController: UINavigationController, mode: SelectionMode) {
        self.childCoordinators = []
        self.navigationController = navigationController
        self.mode = mode
    }

    func start() {
        let service = KakaoAddressService()
        let viewModel = AddressSearchViewModel(addressService: service)
        let viewController = AddressSearchViewController(viewModel: viewModel)
        
        viewModel.output.navBackTapped.sink { [weak self] in
            guard let self else { return }
            self.navigationController.popViewController(animated: true)
        }
        .store(in: &cancellables)
        
//        viewModel.output.navAddressSelected.sink { [weak self] address in
//            guard let self else { return }
//            backAction?(address.replacingOccurrences(of: "서울 ", with: ""))
//        }
//        .store(in: &cancellables)
        
        viewModel.output.navAddressSelected
                   .map { $0.replacingOccurrences(of: "서울 ", with: "") }
                   .sink { [weak self] address in
                       guard let self else { return }

                       switch self.mode {
                       case .onboarding:
//                           self.onAddressSelectedForOnboarding?(address)
                           self.backAction?(address)
                           // ✅ 온보딩도 보통 pop 해서 돌아가는 게 맞음
//                           self.navigationController.popViewController(animated: true)

                       case .changeRegion:
                           self.onAddressSelectedForRegionChange?(address)
                           // ✅ 주소 변경은 즉시 pop
                           self.navigationController.popViewController(animated: true)
                       }
                   }
                   .store(in: &cancellables)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
