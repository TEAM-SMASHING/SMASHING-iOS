//
//  MatchResultCreateViewController.swift
//  SMASHING
//
//  Created by 홍준범 on 1/12/26.
//

import UIKit
import Combine

import SnapKit
import Then


final class MatchResultCreateViewController: BaseViewController {
    
    private let mainView = MatchResultCreateView()
    private let viewModel: MatchResultCreateViewModel
    
    private let input = PassthroughSubject<MatchResultCreateViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(viewModel: MatchResultCreateViewModel) {
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
        
        mainView.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    override func loadView() {
        view = mainView
    }
    
    private func setAddTarget() {
        mainView.winnerDropDown.addTarget(self, action: #selector(didTapWinnerDropDown), for: .touchUpInside)
        mainView.nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        mainView.myOptionButton.addTarget(self, action: #selector(didTapMyOptionButton), for: .touchUpInside)
        mainView.rivalOptionButton.addTarget(self, action: #selector(didTapRivalOptionButton), for: .touchUpInside)
        
        mainView.onScoreChanged = { [weak self] myScore, opponentScore, hasMyScore, hasOpponentScore in
            self?.input.send(.scoreChanged(myScore: myScore, opponentScore: opponentScore, hasMyScore: hasMyScore, hasOpponentScore: hasOpponentScore))
        }
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output.myNickname
            .combineLatest(output.opponentNickname)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] myNickname, opponentNickname in
                self?.mainView.configure(myNickname: myNickname, opponentNickname: opponentNickname)
            }
            .store(in: &cancellables)
        
        output.nextButtonTitle
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.mainView.nextButton.setTitle(title, for: .normal)
            }
            .store(in: &cancellables)
        
        output.toggleDropDown
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.mainView.toggleDropDown()
            }
            .store(in: &cancellables)
        
        output.selectedWinner
            .receive(on: DispatchQueue.main)
            .sink { [weak self] winner in
                self?.mainView.updateSelectedWinner(winner)
            }
            .store(in: &cancellables)
        
        output.prefillData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] prefill in
                self?.mainView.applyPrefillData(myScore: prefill.myScore, opponentScore: prefill.opponentScore)
            }
            .store(in: &cancellables)
        
        output.isNextButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.mainView.nextButton.isEnabled = isEnabled
            }
            .store(in: &cancellables)
        
        output.navToReviewCreate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] gameData, matchResultData, myUserId in
                self?.navigateToReviewCreate(gameData: gameData, matchResultData: matchResultData, myUserId: myUserId)
            }
            .store(in: &cancellables)
        
        output.showSubmitConfirm
            .receive(on: DispatchQueue.main)
            .sink { [weak self] matchResultData in
                self?.showSubmitConfirmPopup(matchResultData: matchResultData)
            }
            .store(in: &cancellables)
        
        output.navToHome
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
            .store(in: &cancellables)
    }
    
    @objc
    private func didTapMyOptionButton() {
        input.send(.myOptionSelected)
    }
    
    @objc
    private func didTapRivalOptionButton() {
        input.send(.rivalOptionSelected)
    }
    
    @objc
    private func didTapWinnerDropDown() {
        input.send(.winnerDropDownTapped)
    }
    
    @objc
    private func didTapNextButton() {
        input.send(.nextButtonTapped)
    }
    
    private func navigateToReviewCreate(gameData: MatchingConfirmedGameDTO, matchResultData: MatchResultData, myUserId: String) {
        let flowType = ReviewFlowType.submission(gameData: gameData, matchResultData: matchResultData, myUserId: myUserId)
        let vc = ReviewCreateViewController(viewModel: ReviewCreateViewModel(flowType: flowType))
        print("게임데이터\(gameData), 매치result\(matchResultData), myuserid\(myUserId)")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showSubmitConfirmPopup(matchResultData: MatchResultData) {
            let popup = SubmitConfirmAlertView()
        popup.configure(title: "매칭 결과를 다시 제출하시겠습니까?", subtitle: "상대가 다시 반려할 경우 매칭 기록은 삭제됩니다.")
            popup.onConfirm = { [weak self] in
                self?.input.send(.submitResubmissionConfirmed(matchResultData))
            }
            popup.onCancel = { }
            view.addSubview(popup)
            popup.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
    
}

struct MatchResultData {
    let winnerUserId: String
    let loserUserId: String
    let scoreWinner: Int
    let scoreLoser: Int
}
