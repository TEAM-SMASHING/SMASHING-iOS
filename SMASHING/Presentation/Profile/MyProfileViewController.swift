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
    
}

final class MyProfileViewModel: MyProfileViewModelProtocol {
    
    enum Input {
        case viewDidLoad
        case viewWillAppear
        case navToAddSports
        case navToTierExplanation
        case navToSeeAllReviews
    }

    struct Output {
        let myProfileFetched = PassthroughSubject<MyProfileListResponse, Never>()
        let myTierFetched = PassthroughSubject<MyProfileTierResponse, Never>()
    }

    let output = Output()
    private var userProfileService: UserProfileService
    private var cancellables: Set<AnyCancellable> = []
    
    init(userProfileService: UserProfileService) {
        self.userProfileService = userProfileService
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> Output {
        input
            .sink { [weak self] input in
                guard let self else { return }
                switch input {
                case .viewDidLoad, .viewWillAppear:
                    userProfileService.fetchMyProfiles()
                        .receive(on: DispatchQueue.main)
                        .sink { completion in
                            print(completion)
                        } receiveValue: { [weak self] response in
                            guard let self else { return }
                            output.myProfileFetched.send(response)
                        }
                        .store(in: &cancellables)
                    
                    userProfileService.fetchMyProfileTier()
                        .receive(on: DispatchQueue.main)
                        .sink { completion in
                            print(completion)
                        } receiveValue: { [weak self] response in
                            guard let self else { return }
                            output.myTierFetched.send(response)
                        }
                        .store(in: &cancellables)
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
        output
            .myProfileFetched
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                guard let self else { return }
                mainView.configure(profile: response)
            }
            .store(in: &cancellables)
        
        output
            .myTierFetched
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                guard let self else { return }
                mainView.configure(tier: response)
            }
            .store(in: &cancellables)
    }
}

extension MyProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TempReview.mockReviews.count > 3 ? 3 : TempReview.mockReviews.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ReviewCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? ReviewCollectionViewCell else { return UICollectionViewCell() }
        
        let data = TempReview.mockReviews[indexPath.item]
        
        cell.configure(data)
        
        cell.contentView.snp.remakeConstraints {
            $0.width.equalTo(collectionView.frame.width)
        }
        
        return cell
    }
}
