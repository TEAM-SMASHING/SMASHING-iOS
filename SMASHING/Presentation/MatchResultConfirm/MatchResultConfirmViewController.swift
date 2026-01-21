//
//  MatchResultConfirmViewController.swift
//  SMASHING
//
//  Created by 홍준범 on 1/21/26.
//

import UIKit
import Combine

import SnapKit
import Then

final class MatchResultConfirmViewController: BaseViewController {
    private let mainView = MatchResultConfirmView()
    private let viewModel: MatchResultConfirmViewModel
    
    private let input = PassthroughSubject<MatchResultConfirmViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(viewModel: MatchResultConfirmViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAddTarget()
        bind()
        view.backgroundColor = .Background.canvas
        input.send(.viewDidLoad)
    }
    
    override func loadView() {
        view = mainView
    }
    
    private func setAddTarget() {
        mainView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
        mainView.rejectButton.addTarget(self, action: #selector(rejectButtonDidTap), for: .touchUpInside)
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output.matchResultData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.mainView.configure(
                    myNickname: data.myNickname,
                    opponentNickname: data.opponentNickname,
                    myScore: data.myScore,
                    opponentScore: data.opponentScore,
                    winnerNickname: data.winnerNickname
                )
            }
            .store(in: &cancellables)
        
        output.navToReviewCreate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] gameId, submissionId, opponentNickname in
                self?.navigateToReviewCreate(gameId: gameId, submissionId: submissionId, opponentNickname: opponentNickname)
            }
            .store(in: &cancellables)
        
        output.showRejectAlert
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.showRejectReasonBottomSheet()
            }
            .store(in: &cancellables)
        
        output.rejectSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
    
    @objc
    private func confirmButtonDidTap() {
        input.send(.confirmButtonTapped)
    }
    
    @objc
    private func rejectButtonDidTap() {
        input.send(.rejectButtonTapped)
    }
    
    private func navigateToReviewCreate(gameId: String, submissionId: String, opponentNickname: String) {
        let flowType = ReviewFlowType.confirmation(
            gameId: gameId,
            submissionId: submissionId,
            opponentNickname: opponentNickname
        )
        let vc = ReviewCreateViewController(
            viewModel: ReviewCreateViewModel(flowType: flowType)
        )
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showRejectReasonBottomSheet() {
        let bottomSheetVC = RejectReasonBottomSheetViewController()
        bottomSheetVC.onReasonSelected = { [weak self] reason in
            self?.viewModel.rejectResult(reason: reason)
            print("바텀 시트 reason\(reason)")
        }
        
        if let sheet = bottomSheetVC.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { _ in
                return 340
            }
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = true
        }
        
        present(bottomSheetVC, animated: true)
    }
}
