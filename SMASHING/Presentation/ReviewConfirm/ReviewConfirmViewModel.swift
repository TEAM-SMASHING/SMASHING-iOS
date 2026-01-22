//
//  ReviewConfirmViewModel.swift
//  SMASHING
//
//  Created by 홍준범 on 1/22/26.
//

import Foundation
import Combine

protocol ReviewConfirmViewModelProtocol: InputOutputProtocol {
    
}

final class ReviewConfirmViewModel: ReviewConfirmViewModelProtocol {
    enum Input {
        case viewDidLoad
        case confirmButtonTapped
    }
    
    struct Output {
        let reviewDetail = PassthroughSubject<ReviewDetailResponse, Never>()
        let navToHome = PassthroughSubject<Void, Never>()
        let isLoading = PassthroughSubject<Bool, Never>()
        let error = PassthroughSubject<NetworkError, Never>()
    }
    
    private let reviewId: String
    private let reviewService: ReviewServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    let output = Output()
    
    init(reviewId: String, reviewService: ReviewServiceProtocol = ReviewService()) {
        self.reviewId = reviewId
        self.reviewService = reviewService
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
            fetchReviewDetail()
        case .confirmButtonTapped:
            output.navToHome.send()
        }
    }
    
    private func fetchReviewDetail() {
        output.isLoading.send(true)
        reviewService.fetchReview(reviewId: reviewId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.output.isLoading.send(false)
                if case .failure(let error) = completion {
                    self.output.error.send(error)
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                self.output.reviewDetail.send(response)
            }
            .store(in: &cancellables)
    }
}
