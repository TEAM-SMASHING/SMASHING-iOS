//
//  MatchResultConfirmViewModel.swift
//  SMASHING
//
//  Created by 홍준범 on 1/21/26.
//

import Foundation
import Combine

protocol MatchResultConfirmViewModelProtocol: InputOutputProtocol {
    
}

final class MatchResultConfirmViewModel: MatchResultConfirmViewModelProtocol {
    enum Input {
        case viewDidLoad
        case confirmButtonTapped
        case rejectButtonTapped
    }
    
    struct Output {
        let matchResultData = PassthroughSubject<MatchResultConfirmData, Never>()
        
        // (gameId, submissionId, opponentNickname)
        let navToReviewCreate = PassthroughSubject<(String, String, String), Never>()
        let showRejectAlert = PassthroughSubject<Void, Never>()
        let rejectSuccess = PassthroughSubject<Void, Never>()
        
        let isLoading = PassthroughSubject<Bool, Never>()
        let error = PassthroughSubject<Error, Never>()
    }
    
    // MARK: - Properties
    
    private let gameService: GameServiceProtocol
    private let gameData: MatchingConfirmedGameDTO
    private let submissionId: String
    
    private let myUserId: String
    private var myNickname: String {
        return KeychainService.get(key: Environment.nicknameKey) ?? ""
    }
    
    
    private var confirmData: MatchResultConfirmData?
    
    private var cancellables = Set<AnyCancellable>()
    let output = Output()
    
    init(
        gameData: MatchingConfirmedGameDTO,
        submissionId: String,
        myUserId: String,
        gameService: GameServiceProtocol = GameService()
    ) {
        self.gameData = gameData
        self.submissionId = submissionId
        self.myUserId = myUserId
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
            fetchSubmissionDetail()
            
        case .confirmButtonTapped:
            // "네, 맞아요" → ReviewCreate로 이동
            guard let confirmData = self.confirmData else { return }
            output.navToReviewCreate.send((gameData.gameID, submissionId, confirmData.opponentNickname))
            
        case .rejectButtonTapped:
            output.showRejectAlert.send()
        }
    }
    
    private func fetchSubmissionDetail() {
        output.isLoading.send(true)
        
        gameService.getSubmissionDetail(gameId: gameData.gameID, submissionId: submissionId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.output.isLoading.send(false)
                if case .failure(let error) = completion {
                    self?.output.error.send(error)
                }
            } receiveValue: { [weak self] dto in
                guard let self else { return }
                let confirmData = self.mapToConfirmData(dto: dto)
                self.confirmData = confirmData
                self.output.matchResultData.send(confirmData)
            }
            .store(in: &cancellables)
    }
    
    private func mapToConfirmData(dto: GameSubmissionDetailDTO) -> MatchResultConfirmData {
        let isMyWin = dto.winner.userId == myUserId
        
        return MatchResultConfirmData(
            myNickname: myNickname,
            opponentNickname: gameData.opponent.nickname,
            myScore: isMyWin ? dto.winner.score : dto.loser.score,
            opponentScore: isMyWin ? dto.loser.score : dto.winner.score,
            winnerNickname: dto.winner.nickname,
            winnerUserId: dto.winner.userId,
            loserUserId: dto.loser.userId,
            scoreWinner: dto.winner.score,
            scoreLoser: dto.loser.score,
            submissionId: submissionId,
            isFirstSubmission: dto.attemptNo == 1
        )
    }
    
    func rejectResult(reason: RejectReason) {
        output.isLoading.send(true)
        print("경기 확인 거절")
        
        gameService.rejectSubmission(gameId: gameData.gameID, submissionId: submissionId, reason: reason.rawValue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.output.isLoading.send(false)
                if case .failure(let error) = completion {
                    self?.output.error.send(error)
                }
            } receiveValue: { [weak self] _ in
                self?.output.rejectSuccess.send()
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - MatchResultConfirmData

struct MatchResultConfirmData {
    let myNickname: String
    let opponentNickname: String
    let myScore: Int
    let opponentScore: Int
    let winnerNickname: String
    let winnerUserId: String
    let loserUserId: String
    let scoreWinner: Int
    let scoreLoser: Int
    let submissionId: String
    let isFirstSubmission: Bool  // attemptNo == 1 여부
}
