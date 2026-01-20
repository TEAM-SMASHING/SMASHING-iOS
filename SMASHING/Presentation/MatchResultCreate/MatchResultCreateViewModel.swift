//
//  MatchResultCreateViewModel.swift
//  SMASHING
//
//  Created by 홍준범 on 1/20/26.
//

import Foundation
import Combine

protocol MatchResultCreateViewModelProtocol: InputOutputProtocol {
    
}

final class MatchResultCreateViewModel: MatchResultCreateViewModelProtocol {
    
    enum Input {
        case viewDidLoad
        case winnerDropDownTapped
        case myOptionSelected
        case rivalOptionSelected
        case scoreChanged(myScore: Int, OpponentScroe: Int)
        case nextButtonTapped
    }
    
    struct Output {
        let gameData = PassthroughSubject<MatchingConfirmedGameDTO, Never>()
        let myNickname = PassthroughSubject<String, Never>()
        let opponentNickname = PassthroughSubject<String, Never>()
        let nextButtonTitle = PassthroughSubject<String, Never>()
        
        let toggleDropDown = PassthroughSubject<Void, Never>()
        let selectedWinner = PassthroughSubject<String, Never>()
        let isNextButtonEnabled = PassthroughSubject<Bool, Never>()
        
        let navToReviewCreate = PassthroughSubject<(MatchingConfirmedGameDTO, MatchResultData, String), Never>()
        let submitResubmission = PassthroughSubject<MatchResultData, Never>()
        
        let isLoading = PassthroughSubject<Bool, Never>()
        let error = PassthroughSubject<Error, Never>()
    }
    
    // MARK: - Properties
    private let gameService: GameServiceProtocol
    private let gameData: MatchingConfirmedGameDTO
    private let myUserId: String
    private let myNickname: String
    
    private var selectedWinner: String?
    private var myScore: Int = 0
    private var opponentScore: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    let output = Output()
    
    
    init(gameData: MatchingConfirmedGameDTO, myUserId: String, myNickname: String, gameService: GameServiceProtocol = GameService()) {
        self.gameData = gameData
        self.myUserId = myUserId
        self.myNickname = myNickname
        self.gameService = gameService
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> Output {
        input
            .sink { [weak self] input in
                guard let self else { return }
                self.handleInput(input)
            }
            .store(in: &cancellables)
        
        return output
    }
    
    private func handleInput(_ input: Input) {
        switch input {
        case .viewDidLoad:
            configureInitialData()
            
        case .winnerDropDownTapped:
            output.toggleDropDown.send()
            
        case .myOptionSelected:
            selectWinner(myNickname)
            
        case .rivalOptionSelected:
            selectWinner(gameData.opponent.nickname)
            
        case .scoreChanged(let myScore, let opponentScore):
            self.myScore = myScore
            self.opponentScore = opponentScore
            validateWinnerAndScore()
            
        case .nextButtonTapped:
            handleNextButtonTapped()
        }
    }
    
    private func configureInitialData() {
        output.gameData.send(gameData)
        output.myNickname.send(myNickname)
        output.opponentNickname.send(gameData.opponent.nickname)
        
        let buttonTitle = gameData.resultStatus.isFirstSubmission ? "다음" : "완료 작성"
        output.nextButtonTitle.send(buttonTitle)
        output.isNextButtonEnabled.send(false)
    }
    
    private func selectWinner(_ winner: String) {
        selectedWinner = winner
        output.selectedWinner.send(winner)
        validateWinnerAndScore()
    }
    
    private func validateWinnerAndScore() {
        guard let selectedWinner = selectedWinner else {
            output.isNextButtonEnabled.send(false)
            return
        }
        
        let isMyWin = (selectedWinner == myNickname)
        let isScoreValid = isMyWin ? (myScore > opponentScore) : (opponentScore > myScore)
        
        output.isNextButtonEnabled.send(isScoreValid)
    }
    
    private func handleNextButtonTapped() {
        let matchResultData = createMatchResultData()
        
        if gameData.resultStatus.isFirstSubmission {
            output.navToReviewCreate.send((gameData, matchResultData, myUserId))
        } else {
            output.submitResubmission.send(matchResultData)
        }
    }
    
    private func createMatchResultData() -> MatchResultData {
        guard let selectedWinner = selectedWinner else {
            return MatchResultData(winnerUserId: "", loserUserId: "", scoreWinner: 0, scoreLoser: 0)
        }
        
        let isMyWin = (selectedWinner == myNickname)
        
        let winnerUserId = isMyWin ? myUserId : gameData.opponent.userID
        let loserUserId = isMyWin ? gameData.opponent.userID : myUserId
        
        let scoreWinner = isMyWin ? myScore : opponentScore
        let scoreLoser = isMyWin ? opponentScore : myScore
        
        return MatchResultData(
            winnerUserId: winnerUserId,
            loserUserId: loserUserId,
            scoreWinner: scoreWinner,
            scoreLoser: scoreLoser
        )
    }
}
