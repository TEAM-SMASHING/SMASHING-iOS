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
}

protocol MatchResultCreateViewModelProtocol: InputOutputProtocol {
    
}

final class MatchResultCreateViewModel: MatchResultCreateViewModelProtocol {
    
    enum Input {
        case viewDidLoad
        case winnerDropDownTapped
        case myOptionSelected
        case rivalOptionSelected
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
        
        let navToReviewCreate = PassthroughSubject<(MatchingConfirmedGameDTO, MatchResultData), Never>()
        let navToHome = PassthroughSubject<Void, Never>()
        
        let isLoading = PassthroughSubject<Bool, Never>()
        let error = PassthroughSubject<Error, Never>()
    }
    
    // MARK: - Properties
    private let gameService: GameServiceProtocol
    private let gameData: MatchingConfirmedGameDTO
    private let myProfileId: String
    private let myNickname: String
    
    private var selectedWinner: String?
    
    private var cancellables = Set<AnyCancellable>()
    let output = Output()
    
    
    init(gameData: MatchingConfirmedGameDTO, myProfileId: String, myNickname: String, gameService: GameServiceProtocol = GameService()) {
        self.gameData = gameData
        self.myProfileId = myProfileId
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
        
        let buttonTitle = gameData.resultStatus.isFirstSubmission ? "다음" : "완료"
        output.nextButtonTitle.send(buttonTitle)
        output.isNextButtonEnabled.send(false)
        
        if shouldPrefillResubmission, let submissionId = gameData.latestSubmissionId {
            fetchSubmissionDetail(submittionId: submissionId)
        }
    }
    
    private func selectWinner(_ winner: String) {
        selectedWinner = winner
        output.selectedWinner.send(winner)
        output.isNextButtonEnabled.send(true)
    }
    
    private func handleNextButtonTapped() {
        let matchResultData = createMatchResultData()
        
        if gameData.resultStatus.isFirstSubmission {
            output.navToReviewCreate.send((gameData, matchResultData))
        } else {
            output.showSubmitConfirm.send(matchResultData)
        }
    }
    
    private func createMatchResultData() -> MatchResultData {
        guard let selectedWinner else {
            return MatchResultData(winnerProfileId: "", loserProfileId: "")
        }
        
        let isMyWin = (selectedWinner == myNickname)
        
        let winnerProfileId = isMyWin ? myProfileId : gameData.opponent.userID
        let loserProfileId = isMyWin ? gameData.opponent.userID : myProfileId
        
        return MatchResultData(winnerProfileId: winnerProfileId, loserProfileId: loserProfileId)
    }
    
    private var shouldPrefillResubmission: Bool {
        guard gameData.resultStatus == .resultRejected else { return false }
        guard let latestSubmitterId = gameData.latestSubmitterId else { return false }
        return latestSubmitterId == myProfileId
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
                let isMyWin = dto.winner.profileId == self.myProfileId
                let winnerNickname = isMyWin ? self.myNickname : self.gameData.opponent.nickname
                self.selectedWinner = winnerNickname
                self.output.prefillData.send(MatchResultPrefillData(winnerNickname: winnerNickname))
                self.output.selectedWinner.send(winnerNickname)
                self.output.isNextButtonEnabled.send(true)
            }
            .store(in: &cancellables)
    }
    
    private func submitResubmission(_ matchResultData: MatchResultData) {
        output.isLoading.send(true)
        
        let request = GameSubmissionRequestDTO(
            winnerProfileId: matchResultData.winnerProfileId,
            loserProfileId: matchResultData.loserProfileId,
            review: nil
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
