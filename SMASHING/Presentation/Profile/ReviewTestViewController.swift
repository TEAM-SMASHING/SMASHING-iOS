//
//  ReviewTestViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/19/26.
//

import UIKit
import Combine

final class ReviewTestViewController: UIViewController {
    
    private let reviewService: UserReviewServiceType = UserReviewService()
    private var cancellables = Set<AnyCancellable>()
    
    // 이전에 사용하셨던 테스트용 토큰을 그대로 사용합니다.
    let accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIwUDc1VjFSU0QyUkpSIiwidHlwZSI6IkFDQ0VTU19UT0tFTiIsInJvbGVzIjpbXSwiaWF0IjoxNzY4NzQ3NTk5LCJleHAiOjEyMDk3NzY4NzQ3NTk5fQ.ZKxXZ0eVGIXWb11S5OZnHt0UA9A0JyNtcyHXn4-W6vc"
    
    // MARK: - UI Components
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        setupButtons()
    }
    
    private func setupLayout() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func setupButtons() {
        addButton(title: "1. 내 리뷰 요약 조회", action: #selector(testFetchMyReviewSummary))
        addButton(title: "2. 내 최근 리뷰 목록 조회", action: #selector(testFetchMyRecentReviews))
        addButton(title: "3. 타 유저 리뷰 요약 조회", action: #selector(testFetchOtherUserReviewSummary))
        addButton(title: "4. 타 유저 최근 리뷰 목록 조회", action: #selector(testFetchOtherUserRecentReviews))
    }
    
    private func addButton(title: String, action: Selector) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: action, for: .touchUpInside)
        stackView.addArrangedSubview(button)
    }
}

// MARK: - Test Methods
extension ReviewTestViewController {
    
    @objc private func testFetchMyReviewSummary() {
        print("🚀 [TEST] 내 리뷰 요약 조회 시작...")
        reviewService.fetchMyReviewSummary()
            .sink { [weak self] completion in
                self?.handleCompletion(completion, label: "내 리뷰 요약")
            } receiveValue: { response in
                print("✅ [SUCCESS] 내 리뷰 요약 데이터 수신")
                print("   - 최고예요: \(response.ratingCounts.best), 좋아요: \(response.ratingCounts.good), 별로예요: \(response.ratingCounts.bad)")
            }
            .store(in: &cancellables)
    }
    
    @objc private func testFetchMyRecentReviews() {
        print("🚀 [TEST] 내 최근 리뷰 목록 조회 시작 (size: 10)...")
        reviewService.fetchMyRecentReviews(size: 10, cursor: nil)
            .sink { [weak self] completion in
                self?.handleCompletion(completion, label: "내 최근 리뷰 목록")
            } receiveValue: { response in
                print("✅ [SUCCESS] 내 리뷰 \(response.results.count)건 수신 (HasNext: \(response.hasNext))")
                response.results.forEach { print("   - [\(String(describing: $0.opponentNickname))] \($0.content ?? "내용 없음")") }
            }
            .store(in: &cancellables)
    }
    
    @objc private func testFetchOtherUserReviewSummary() {
        let dummyUserId = "0KGFXTJE1ECZT"
        print("🚀 [TEST] 타 유저 리뷰 요약 조회 시작 (ID: \(dummyUserId), 종목: 탁구)...")
        reviewService.fetchOtherUserReviewSummary(userId: dummyUserId, sport: .tableTennis)
            .sink { [weak self] completion in
                self?.handleCompletion(completion, label: "타 유저 리뷰 요약")
            } receiveValue: { response in
                print("✅ [SUCCESS] 타 유저 리뷰 요약 수신")
                print("   - 매너태그(Good): \(response.tagCounts.goodManner), 시간엄수: \(response.tagCounts.onTime)")
            }
            .store(in: &cancellables)
    }
    
    @objc private func testFetchOtherUserRecentReviews() {
        let dummyUserId = "0KGFXTJE1ECZT"
        print("🚀 [TEST] 타 유저 최근 리뷰 목록 조회 시작 (ID: \(dummyUserId), 종목: 탁구)...")
        reviewService.fetchOtherUserRecentReviews(userId: dummyUserId, sport: .tableTennis, size: 5, cursor: nil)
            .sink { [weak self] completion in
                self?.handleCompletion(completion, label: "타 유저 최근 리뷰 목록")
            } receiveValue: { response in
                print("✅ [SUCCESS] 타 유저 리뷰 \(response.results.count)건 수신")
                response.results.forEach { print("   - [\($0.opponentNickname)] \($0.content ?? "내용 없음")") }
            }
            .store(in: &cancellables)
    }
    
    private func handleCompletion(_ completion: Subscribers.Completion<NetworkError>, label: String) {
        switch completion {
        case .finished:
            print("🏁 [FINISHED] \(label) 테스트 완료")
        case .failure(let error):
            print("❌ [FAILURE] \(label) 에러 발생: \(error)")
        }
    }
}
