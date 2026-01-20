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
    
    private let gameSerive: GameServiceProtocol
    
    private let gameData: MatchingConfirmedGameDTO
    private let matchResultData: MatchResultData
    private let myUserId: String
    
    init(gameData: MatchingConfirmedGameDTO, matchResultData: MatchResultData, myUserId: String, gameSerivce: GameServiceProtocol) {
        self.gameData = gameData
        self.matchResultData = matchResultData
        self.myUserId = myUserId
        self.gameSerive = gameSerivce
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    
    private let mainView = ReviewCreateView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Background.canvas
        setAddTarget()
        configureView()
    }
    
    private func configureView() {
        mainView.configure(opponentNickname: gameData.opponent.nickname)
    }
    
    private func setAddTarget() {
        mainView.submitButton.addTarget(self, action: #selector(submitButtonDidTap), for: .touchUpInside)
    }
    
    @objc
    private func submitButtonDidTap() {
        print("제출 버튼 눌림")
        submitFirstResult()
    }
    
    private func submitFirstResult() {
        guard let reviewData = mainView.getReviewData() else {
            //만족도 선택 필수 알림
            print("만족도 선택 안했어요")
            return
        }
        
        let reviewRequestDTO = ReviewRequestDTO(rating: reviewData.rating.rawValue, content: reviewData.content, tags: reviewData.tags.isEmpty ? nil : reviewData.tags.map { $0.rawValue }
        )
        
        let requestDTO = GameFirstSubmissionRequestDTO(
            winnerUserId: matchResultData.winnerUserId,
            loserUserId: matchResultData.loserUserId,
            scoreWinner: matchResultData.scoreWinner,
            scoreLoser: matchResultData.scoreLoser,
            review: reviewRequestDTO
        )
        
        print("reviewRequestDTO\(reviewRequestDTO)")
        print("requestDTO\(requestDTO)")
        gameSerive.submitResult(gameId: gameData.gameID, request: requestDTO)
            .sink { [weak self] completion in
                guard let self else { return }
                if case .failure(let error) = completion {
                    self.handleSubmitError(error)
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                self.handleSubmitSuccess(response)
            }
            .store(in: &cancellables)
    }
    private func handleSubmitSuccess(_ response: GameSubmissionResponseDTO) {
        // TODO: 성공 시 홈 화면으로 이동 또는 완료 알림
        print("제출 성공 - reviewId: \(response.reviewId ?? "없음")")
        navigationController?.popToRootViewController(animated: true)
    }

    private func handleSubmitError(_ error: NetworkError) {
        // TODO: 에러 알림 표시
        print("제출 실패 - error: \(error)")
    }

}

// MARK: - ReviewData

struct ReviewData {
    let rating: ReviewScore
    let content: String?
    let tags: [ReviewTag]
}
