//
//  ReviewConfirmViewCnotroller.swift
//  SMASHING
//
//  Created by 홍준범 on 1/22/26.
//

import UIKit
import Combine

import SnapKit
import Then

final class ReviewConfirmViewController: BaseViewController {
    
    private let mainView = ReviewConfirmView()
    private let viewModel: ReviewConfirmViewModel
    
    private let input = PassthroughSubject<ReviewConfirmViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ReviewConfirmViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAddTarget()
        bind()
        input.send(.viewDidLoad)
    }
    
    private func setAddTarget() {
        mainView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output.reviewDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] detail in
                self?.mainView.configure(data: detail)
            }
            .store(in: &cancellables)
        
        output.navToHome
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
            .store(in: &cancellables)
        
        output.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.mainView.confirmButton.isEnabled = !isLoading
            }
            .store(in: &cancellables)
        
        output.error
            .receive(on: DispatchQueue.main)
            .sink { error in
                print("후기 조회 실패: \(error)")
            }
            .store(in: &cancellables)
    }
    
    @objc
    private func confirmButtonDidTap() {
        input.send(.confirmButtonTapped)
    }
}
