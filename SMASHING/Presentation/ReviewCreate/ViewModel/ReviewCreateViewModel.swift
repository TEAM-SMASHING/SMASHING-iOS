//
//  ReviewCreateViewModel.swift
//  SMASHING
//
//  Created by 홍준범 on 1/20/26.
//

import Foundation
import Combine

protocol ReviewCreateViewModelProtocol: InputOutputProtocol {
    
}

final class ReviewCreateViewModel: ReviewCreateViewModelProtocol {
    
    enum Input {
        case viewDidLoad
        case satisfactionSelected(ReviewScore)
        case rapidReviewTagsChanged([ReviewTag])
        case reviewContentChanged(String?)
        case submitButtonTapped
    }
    
    struct Output {
        let opponentNickname = PassthroughSubject<String, Never>()
        let isSubmitButtonEnabled = PassthroughSubject<Bool, Never>()
        let navToHome = PassthroughSubject<Void, Never>()
        let isLoading = PassthroughSubject<Bool, Never>()
        let error = PassthroughSubject<NetworkError, Never>()
    }
    
    // MARK: - Properties
    private let gameService: GameServiceProtocol
    private let gameData: MatchingConfirmedGameDTO
    private let matchResultData: MatchResultData
    private let myUserId: String
    
    private var selectedSatisfaction: ReviewScore?
    private var selectedTags: [ReviewTag] = []
    private var reviewContent: String?
    
    private var cancellables = Set<AnyCancellable>()
    let output = Output()
    
    init(
        gameData: MatchingConfirmedGameDTO,
        matchResultData: MatchResultData,
        myUserId: String,
        gameService: GameServiceProtocol = GameService()
    ) {
        self.gameData = gameData
        self.matchResultData = matchResultData
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
            configureInitialData()
            
        case .satisfactionSelected(let score):
            selectedSatisfaction = score
            output.isSubmitButtonEnabled.send(true)
            
        case .rapidReviewTagsChanged(let tags):
            selectedTags = tags
            
        case .reviewContentChanged(let content):
            reviewContent = content
            
        case .submitButtonTapped:
            submitReview()
        }
    }
    
    private func configureInitialData() {
        output.opponentNickname.send(gameData.opponent.nickname)
        output.isSubmitButtonEnabled.send(false)
    }
    
    private func submitReview() {
        guard let satisfaction = selectedSatisfaction else {
            print("만족도 선택 안했어요")
            return
        }
        
        output.isLoading.send(true)
        
        let reviewRequestDTO = ReviewRequestDTO(
            rating: satisfaction.rawValue,
            content: reviewContent,
            tags: selectedTags.isEmpty ? nil : selectedTags.map { $0.rawValue }
        )
        
        let requestDTO = GameFirstSubmissionRequestDTO(
            winnerUserId: matchResultData.winnerUserId,
            loserUserId: matchResultData.loserUserId,
            scoreWinner: matchResultData.scoreWinner,
            scoreLoser: matchResultData.scoreLoser,
            review: reviewRequestDTO
        )
        
        print("reviewRequestDTO: \(reviewRequestDTO)")
        print("requestDTO: \(requestDTO)")
        
        gameService.submitResult(gameId: gameData.gameID, request: requestDTO)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.output.isLoading.send(false)
                if case .failure(let error) = completion {
                    self.output.error.send(error)
                    print("제출 실패 - error: \(error)")
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                print("제출 성공 - reviewId: \(response.reviewId ?? "없음")")
                self.output.navToHome.send()
            }
            .store(in: &cancellables)
    }
}
