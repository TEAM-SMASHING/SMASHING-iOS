//
//  MyprofileViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/15/26.
//

import Combine
import UIKit

import SnapKit
import Then

final class MyProfileViewController: BaseViewController {

    // MARK: - Properties

    private lazy var mainView = MyProfileView().then {
        $0.tierCard.tierDetailAction = { self.inputSubject.send(.tierExplanationTapped) }
    }
    private let viewModel: MyProfileViewModel
    private let inputSubject = PassthroughSubject<MyProfileViewModel.Input, Never>()

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init

    init() {
        let profileService = UserProfileService()
        let reviewService = UserReviewService()
        self.viewModel = MyProfileViewModel(userProfileService: profileService, userReviewService: reviewService)
        super.init(nibName: nil, bundle: nil)
    }

    init(viewModel: any MyProfileViewModelProtocol) {
        self.viewModel = viewModel as! MyProfileViewModel
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
        mainView.reviewCard.seeAllAction = { self.inputSubject.send(.seeAllReviewsTapped) }
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputSubject.send(.viewWillAppear)
    }

    private func bind() {
        let output = viewModel.transform(input: inputSubject.eraseToAnyPublisher())

        mainView.tierCard.onSportsAction = { [weak self] sport in
            self?.inputSubject.send(.sportsCellTapped(sport))
        }

        mainView.tierCard.tierDetailAction = { [weak self] in
            self?.inputSubject.send(.tierExplanationTapped)
        }

        output
            .myProfileFetched
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                guard let self else { return }
                mainView.configure(profile: response)
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

        // MARK: - Navigation Bindings (from ProfileCoordinator)

        output.navigateToAddSports
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.showAddSports()
            }
            .store(in: &cancellables)

        output.navToSeeAllReviews
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.showAllReviews()
            }
            .store(in: &cancellables)

        output.navToTierExplanation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.showTierExplanation()
            }
            .store(in: &cancellables)
    }

    // MARK: - Navigation Methods

    private func showAddSports() {
        let addSportsVC = AddSportsViewController()
        NavigationManager.shared.push(addSportsVC, hidesBottomBar: true)
    }

    private func showAllReviews() {
        let service = UserReviewService()
        let viewModel = MyReviewsViewModel(service: service)
        let vc = MyReviewsViewController(viewModel: viewModel)
        NavigationManager.shared.push(vc, hidesBottomBar: true)
    }

    private func showTierExplanation() {
        let tierViewController = TierExplanationViewController(sports: .badminton, oreTier: .bronze)
        tierViewController.dismissAction = {
            NavigationManager.shared.dismiss()
        }
        NavigationManager.shared.present(tierViewController)
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
