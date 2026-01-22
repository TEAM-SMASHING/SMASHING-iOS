//
//  MatchResultCreateViewModel.swift
//  SMASHING
//
//  Created by 홍준범 on 1/20/26.
//

import Foundation
import Combine

// MARK: - MatchResultPrefillData

struct MatchResultPrefillData {
    let winnerNickname: String
    let myScore: Int
    let opponentScore: Int
}

protocol MatchResultCreateViewModelProtocol: InputOutputProtocol {
    
}

final class MatchResultCreateViewModel: MatchResultCreateViewModelProtocol {
    
    enum Input {
        case viewDidLoad
        case winnerDropDownTapped
        case myOptionSelected
        case rivalOptionSelected
        case scoreChanged(myScore: Int?, opponentScore: Int?, hasMyScore: Bool, hasOpponentScore: Bool)
        case nextButtonTapped
        case submitResubmissionConfirmed(MatchResultData)
    }
    
    struct Output {
        let gameData = PassthroughSubject<MatchingConfirmedGameDTO, Never>()
        let myNickname = PassthroughSubject<String, Never>()
        let opponentNickname = PassthroughSubject<String, Never>()
        let nextButtonTitle = PassthroughSubject<String, Never>()
        let prefillData = PassthroughSubject<MatchResultPrefillData, Never>()
        
        let toggleDropDown = PassthroughSubject<Void, Never>()
        let selectedWinner = PassthroughSubject<String, Never>()
        let isNextButtonEnabled = PassthroughSubject<Bool, Never>()
        
        let showSubmitConfirm = PassthroughSubject<MatchResultData, Never>()
        
        let navToReviewCreate = PassthroughSubject<(MatchingConfirmedGameDTO, MatchResultData, String), Never>()
        let navToHome = PassthroughSubject<Void, Never>()
        
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
    private var hasMyScore: Bool = false
    private var hasOpponentScore: Bool = false
    
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
        case .scoreChanged(let myScore, let opponentScore, let hasMyScore, let hasOpponentScore):
            self.myScore = myScore ?? 0
            self.opponentScore = opponentScore ?? 0
            self.hasMyScore = hasMyScore
            self.hasOpponentScore = hasOpponentScore
            validateWinnerAndScore()
        case .nextButtonTapped:
            handleNextButtonTapped()
        case .submitResubmissionConfirmed(let matchResultData):
            submitResubmission(matchResultData)
        }
    }
    
    private func configureInitialData() {
        output.gameData.send(gameData)
        output.myNickname.send(myNickname)
        output.opponentNickname.send(gameData.opponent.nickname)
        
        let buttonTitle = gameData.resultStatus.isFirstSubmission ? "다음" : "완료" //여기 해야함
        output.nextButtonTitle.send(buttonTitle)
        output.isNextButtonEnabled.send(false)
        
        if shouldPrefillResubmission, let submissionId = gameData.latestSubmissionId {
            fetchSubmissionDetail(submittionId: submissionId)
        }
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
        
        guard hasMyScore, hasOpponentScore else {
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
            output.showSubmitConfirm.send(matchResultData)
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
    
    private var shouldPrefillResubmission: Bool {
        guard gameData.resultStatus == .resultRejected else { return false }
        guard let latestSubmitterId = gameData.latestSubmitterId else { return false }
        return latestSubmitterId == myUserId
    }
    
    private func fetchSubmissionDetail(submittionId: String) {
        output.isLoading.send(true)
        gameService.getSubmissionDetail(gameId: gameData.gameID, submissionId: submittionId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.output.isLoading.send(false)
                if case .failure(let error) = completion {
                    self.output.error.send(error)
                }
            } receiveValue: { [weak self] dto in
                guard let self else { return }
                let matchResultData = MatchResultData(winnerUserId: dto.winner.userId, loserUserId: dto.loser.userId, scoreWinner: dto.winner.score, scoreLoser: dto.loser.score)
                let isMyWin = matchResultData.winnerUserId == self.myUserId
                let prefill = MatchResultPrefillData(winnerNickname: isMyWin ? self.myNickname : self.gameData.opponent.nickname, myScore: isMyWin ? matchResultData.scoreWinner : matchResultData.scoreLoser, opponentScore: isMyWin ? matchResultData.scoreLoser : matchResultData.scoreWinner)
                self.selectedWinner = prefill.winnerNickname
                self.myScore = prefill.myScore
                self.opponentScore = prefill.opponentScore
                self.output.prefillData.send(prefill)
                self.output.selectedWinner.send(prefill.winnerNickname)
                self.validateWinnerAndScore()
            }
            .store(in: &cancellables)
    }
    
    private func submitResubmission(_ matchResultData: MatchResultData) {
        output.isLoading.send(true)
        
        let request = GameResubmissionRequestDTO(
            winnerUserId: matchResultData.winnerUserId,
            loserUserId: matchResultData.loserUserId,
            scoreWinner: matchResultData.scoreWinner,
            scoreLoser: matchResultData.scoreLoser
        )
        
        gameService.resubmitResult(gameId: gameData.gameID, request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.output.isLoading.send(false)
                if case .failure(let error) = completion {
                    self.output.error.send(error)
                }
            } receiveValue: { [weak self] _ in
                self?.output.navToHome.send()
            }
            .store(in: &cancellables)
    }
}
