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
    }
    
    override func loadView() {
        view = mainView
    }
    
    private func setAddTarget() {
        mainView.winnerDropDown.addTarget(self, action: #selector(didTapWinnerDropDown), for: .touchUpInside)
        mainView.nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        mainView.myOptionButton.addTarget(self, action: #selector(didTapMyOptionButton), for: .touchUpInside)
        mainView.rivalOptionButton.addTarget(self, action: #selector(didTapRivalOptionButton), for: .touchUpInside)
        
        mainView.onScoreChanged = { [weak self] myScore, opponentScore in
            self?.input.send(.scoreChanged(myScore: myScore, opponentScore: opponentScore))
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
        
        output.submitResubmission
            .receive(on: DispatchQueue.main)
            .sink { [weak self] matchResultData in
                self?.handleResubmission(matchResultData)
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
        let vc = ReviewCreateViewController(viewModel: ReviewCreateViewModel(gameData: gameData, matchResultData: matchResultData, myUserId: myUserId))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleResubmission(_ matchResultData: MatchResultData) {
           // TODO: Resubmission API 호출 구현
           print("Resubmission data: \(matchResultData)")
       }
    
}

struct MatchResultData {
    let winnerUserId: String
    let loserUserId: String
    let scoreWinner: Int
    let scoreLoser: Int
}
