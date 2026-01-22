//
//  MatchResultCreateSecondViewController.swift
//  SMASHING
//
//  Created by 홍준범 on 1/13/26.
//

import UIKit
import Combine

import Then
import SnapKit

final class ReviewCreateViewController: BaseViewController {
    
    private let viewModel: ReviewCreateViewModel
    
    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<ReviewCreateViewModel.Input, Never>()
    
    init(viewModel: ReviewCreateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let mainView = ReviewCreateView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Background.canvas
        setAddTarget()
        bindKeyboard()
        bind()
        input.send(.viewDidLoad)
        mainView.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @MainActor deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output.opponentNickname
            .receive(on: DispatchQueue.main)
            .sink { [weak self] nickname in
                self?.mainView.configure(opponentNickname: nickname)
            }
            .store(in: &cancellables)
        
        output.isSubmitButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.mainView.submitButton.isEnabled = isEnabled
            }
            .store(in: &cancellables)
        
        output.navToHome
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
            .store(in: &cancellables)
        
        output.navToReviewConfirm
            .receive(on: DispatchQueue.main)
            .sink { [weak self] reviewId in
                self?.navigateToReviewConfirm(reviewId: reviewId)
            }
            .store(in: &cancellables)
        
        output.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.mainView.submitButton.isEnabled = !isLoading
            }
            .store(in: &cancellables)
        
        output.error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                // TODO: 에러 알림 표시
                print("에러 발생: \(error)")
            }
            .store(in: &cancellables)
    }
    
    private func setAddTarget() {
        mainView.submitButton.addTarget(self, action: #selector(submitButtonDidTap), for: .touchUpInside)
        
        mainView.onSatisfactionSelected = { [weak self] score in
            self?.input.send(.satisfactionSelected(score))
        }
        
        mainView.onRapidReviewTagsChanged = { [weak self] tags in
            self?.input.send(.rapidReviewTagsChanged(tags))
        }
        
        mainView.onReviewContentChanged = { [weak self] content in
            self?.input.send(.reviewContentChanged(content))
        }
    }
    
    private func bindKeyboard() {
        bindKeyboardToSafeArea()
            .store(in: &cancellables)
    }
    
    @objc
    private func submitButtonDidTap() {
        view.endEditing(true)
        showSubmitConfirmPopup()
    }
    
    private func showSubmitConfirmPopup() {
        let popup = SubmitConfirmAlertView()
        let text = viewModel.submitPopupText
        popup.configure(title: text.title, subtitle: text.subtitle)
        

        popup.onConfirm = { [weak self] in
            self?.input.send(.submitButtonTapped)
        }
        
        popup.onCancel = { }
        view.addSubview(popup)
        popup.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func navigateToReviewConfirm(reviewId: String) {
        let viewModel = ReviewConfirmViewModel(reviewId: reviewId)
        let vc = ReviewConfirmViewController(viewModel: viewModel)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
