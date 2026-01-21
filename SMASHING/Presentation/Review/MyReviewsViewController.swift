//
//  MyReviewsViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/14/26.
//

import Combine
import UIKit

import SnapKit
import Then

protocol MyReviewsViewModelProtocol: InputOutputProtocol
    where Input == MyReviewsViewModel.Input,
          Output == MyReviewsViewModel.Output {
    
    var reviews: [RecentReviewResult] {get}
}

final class MyReviewsViewModel: MyReviewsViewModelProtocol {
    
    enum Input {
        case viewDidLoad
        case viewWillAppear
        case reachedBottom
        case backButtonDidTap
    }
    
    struct Output {
        let dataFetched = PassthroughSubject<Void, Never>()
        let reviewSummaryFetched = PassthroughSubject<ReviewSummaryResponse, Never>()
        let revieReviewFetched = PassthroughSubject<Void, Never>()
        let navBack = PassthroughSubject<Void, Never>()
    }
    
    let output = Output()
    var cancellables: Set<AnyCancellable> = []
    
    let service: UserReviewServiceProtocol
    
    private var nextCursor: String?
    private var hasNext: Bool = true
    var reviews = [RecentReviewResult]()
    
    private var isFetching = false
    
    init(service: UserReviewServiceProtocol) {
        self.service = service
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> Output {
        input
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .viewDidLoad:
                    fetchSummary()
                    fetchRecentReviews(isFirstPage: true)
                case .viewWillAppear:
                    self.fetchSummary()
                case .reachedBottom:
                    // ToDo: - 분기 처리
                    self.fetchRecentReviews(isFirstPage: false)
                case .backButtonDidTap:
                    self.output.navBack.send()
                }
            }
            .store(in: &cancellables)
        return output
    }
    
    private func fetchSummary() {
        self.service.fetchMyReviewSummary()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                self?.output.reviewSummaryFetched.send(response)
            })
            .store(in: &self.cancellables)
    }
    
    private func fetchRecentReviews(isFirstPage: Bool) {
        guard !isFetching && (isFirstPage || hasNext) else { return }
        
        isFetching = true
        let cursor = isFirstPage ? nil : nextCursor
        
        self.service.fetchMyRecentReviews(size: 10, cursor: cursor)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.isFetching = false
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                if isFirstPage {
                    self.reviews = response.results
                } else {
                    self.reviews.append(contentsOf: response.results)
                }
                self.nextCursor = response.nextCursor
                self.hasNext = response.hasNext
                
                self.output.dataFetched.send()
                self.isFetching = false
            })
            .store(in: &self.cancellables)
    }
}

final class MyReviewsViewController: BaseViewController, UICollectionViewDelegate {
    
    // MARK: - Properties
    
    var backAction: (() -> Void)?
    private let myReviewsView = MyReviewsView()
    private let viewModel: any MyReviewsViewModelProtocol
    private let inputSubject = PassthroughSubject<MyReviewsViewModel.Input, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Life Cycle
    
    init(viewModel: any MyReviewsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = myReviewsView
        setupDelegate()
        bind()
        inputSubject.send(.viewDidLoad)
    }
    
    private func setupDelegate() {
        myReviewsView.collectionView.delegate = self
        myReviewsView.collectionView.dataSource = self
    }
    
    private func bind() {
        let output = viewModel.transform(input: inputSubject.eraseToAnyPublisher())
        
        output.dataFetched
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.myReviewsView.collectionView.reloadData()
            }
            .store(in: &cancellables)
            
        output.reviewSummaryFetched
            .receive(on: DispatchQueue.main)
            .sink { [weak self] summary in
                self?.myReviewsView.configure(summary: summary)
            }
            .store(in: &cancellables)
        
        myReviewsView.collectionView.reachedBottomPublisher
            .sink { [weak self] _ in
                self?.inputSubject.send(.reachedBottom)
            }
            .store(in: &cancellables)
        
        myReviewsView.backAction = { [weak self] in
            self?.inputSubject.send(.backButtonDidTap)
        }
        
        output.navBack
            .sink { [weak self] in
                self?.backAction?()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDataSource

extension MyReviewsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.reviews.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ReviewCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? ReviewCollectionViewCell else { return UICollectionViewCell() }
        
        let data = viewModel.reviews[indexPath.item]
        
        cell.configure(data)
        
        cell.contentView.snp.remakeConstraints {
            $0.width.equalTo(collectionView.frame.width)
        }
        
        return cell
    }
}
