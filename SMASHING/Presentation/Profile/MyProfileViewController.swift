//
//  MyprofileViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/15/26.
//

import UIKit

import SnapKit
import Then

import Combine

protocol MyProfileViewModelProtocol: InputOutputProtocol where Input == MyProfileViewModel.Input, Output == MyProfileViewModel.Output{
    var reviewPreviews: [RecentReviewResult] { get }
}

final class MyProfileViewModel: MyProfileViewModelProtocol {
    
    enum Input {
        case viewDidLoad
        case viewWillAppear
        case sportsCellTapped(Sports?)
        case navToAddSports
        case navToTierExplanation
        case navToSeeAllReviews
    }

    struct Output {
        let myProfileFetched = PassthroughSubject<MyProfileListResponse, Never>()
        let myReviewSummaryFetched = PassthroughSubject<ReviewSummaryResponse, Never>()
        let myRecentReviewListFetched = PassthroughSubject<[RecentReviewResult], Never>()
        let navigateToAddSports = PassthroughSubject<Void, Never>()
    }

    let output = Output()
    var reviewPreviews: [RecentReviewResult] = []
    private var userProfileService: UserProfileService
    private var userReviewService: UserReviewServiceProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(userProfileService: UserProfileService, userReviewService: UserReviewServiceProtocol) {
        self.userProfileService = userProfileService
        self.userReviewService = userReviewService
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> Output {
        input
            .sink { [weak self] input in
                guard let self else { return }
                switch input {
                case .viewDidLoad, .viewWillAppear:
                    userProfileService.fetchMyProfiles()
                        .receive(on: DispatchQueue.main)
                        .sink { _ in
                        } receiveValue: { [weak self] response in
                            guard let self else { return }
                            output.myProfileFetched.send(response)
                        }
                        .store(in: &cancellables)
                    
                    userReviewService.fetchMyRecentReviews(size: 3, cursor: nil)
                        .receive(on: DispatchQueue.main)
                        .sink { _ in
                        } receiveValue: { [weak self] response in
                            guard let self else { return }
                            self.reviewPreviews = response.results
                            output.myRecentReviewListFetched.send(response.results)
                        }
                        .store(in: &cancellables)
                    
                    userReviewService.fetchMyReviewSummary()
                        .receive(on: DispatchQueue.main)
                        .sink { _ in
                        } receiveValue: { [weak self] response in
                            guard let self else { return }
                            output.myReviewSummaryFetched.send(response)
                        }
                        .store(in: &cancellables)
                case .sportsCellTapped(let sport):
                    if let sport = sport {
                        // TODO: 해당 종목의 프로필로 데이터 전환 로직 (updateActiveProfile 등 호출 가능)
                        print("\(sport.displayName) 프로필 전환")
                    } else {
                        // nil이면 종목 추가 화면으로 이동
                        output.navigateToAddSports.send()
                    }
                case .navToAddSports:
                    break
                case .navToTierExplanation:
                    break
                case .navToSeeAllReviews:
                    break
                }
            }
            .store(in: &cancellables)
        return output
    }
}

final class MyProfileViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let mainView = MyProfileView()
    private let viewModel: any MyProfileViewModelProtocol
    private let inputSubject = PassthroughSubject<MyProfileViewModel.Input, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    
    init(viewModel: any MyProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        view = mainView
        inputSubject.send(.viewDidLoad)
        mainView.reviewCard.reviewCollectionView.delegate = self
        mainView.reviewCard.reviewCollectionView.dataSource = self
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        inputSubject.send(.viewWillAppear)
    }
    
    private func bind() {
        let output = viewModel.transform(input: inputSubject.eraseToAnyPublisher())
        
        mainView.tierCard.onSportsAction = { [weak self] sport in
            self?.inputSubject.send(.sportsCellTapped(sport))
        }
        
        output
            .myProfileFetched
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                guard let self else { return }
                mainView.configure(profile: response)
                // TierCard의 CollectionView 데이터 갱신
                // TODO: Response에서 전체 종목 리스트를 추출하여 전달해야 함
                // 예: self.mainView.tierCard.reloadSports(with: response.allProfiles.map { $0.sport })
            }
            .store(in: &cancellables)
        
        output
            .myRecentReviewListFetched
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                guard let self else { return }
                let isEmpty = response.isEmpty
                mainView.reviewCard.updateEmptyState(isEmpty: isEmpty)
                
                if !isEmpty {
                    mainView.reviewCard.reviewCollectionView.reloadData()
                    DispatchQueue.main.async {
                        self.mainView.reviewCard.updateCollectionViewHeight(with: response)
                        self.view.layoutIfNeeded()
                    }
                }
            }
            .store(in: &cancellables)
        
        output
            .myReviewSummaryFetched
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                guard let self else { return }
                mainView.configure(summury: response)
            }
            .store(in: &cancellables)
    }
}

extension MyProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.reviewPreviews.count > 3 ? 3 : viewModel.reviewPreviews.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ReviewCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? ReviewCollectionViewCell else { return UICollectionViewCell() }
        
        let data = viewModel.reviewPreviews[indexPath.item]
        
        cell.configure(data)
        cell.contentView.snp.remakeConstraints {
            $0.width.equalTo(collectionView.frame.width)
        }

        return cell
    }
}
