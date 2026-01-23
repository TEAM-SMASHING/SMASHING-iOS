//
//  RankingViewController.swift
//  SMASHING
//
//  Created by 홍준범 on 1/15/26.
//

import UIKit
import Combine

import SnapKit
import Then

final class RankingViewController: BaseViewController {
    
    
    // MARK: - Properties
    
    private var rankings: [RankingUserDTO] = []
    private var myRanking: MyRankingDTO?
    private var topThreeUsers: [RankingUserDTO] = []
    
    private let viewModel: RankingViewModel
    private let input = PassthroughSubject<RankingViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(viewModel: RankingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    private let mainView = RankingView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Background.canvas
        setCollectionView()
        
        mainView.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.topThreePodium.onUserTapped = { [weak self] userId in
            self?.input.send(.rankingUserTapped(userId: userId))
        }
        
        bind()
        input.send(.viewDidLoad)
    }
    
    // MARK: - Private Methods
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output.topThreeUsers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users in
                self?.topThreeUsers = users
                self?.updateTopThreePodium()
            }
            .store(in: &cancellables)
        
        output.rankings
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rankings in
                self?.rankings = rankings
                self?.mainView.rankingCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        output.isEmpty
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEmpty in
                self?.mainView.updateEmptyState(isEmpty: isEmpty)
            }
            .store(in: &cancellables)
        
        output.error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                print("Error: \(error.localizedDescription)")
            }
            .store(in: &cancellables)
        
        output.myRanking
            .receive(on: DispatchQueue.main)
            .sink { [weak self] myRank in
                self?.myRanking = myRank
                self?.updateMyRanking()
            }
            .store(in: &cancellables)
        
        output.navigateToUserProfile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userId in
                self?.showUserProfile(userId: userId)
            }
            .store(in: &cancellables)
    }
    
    private func setCollectionView() {
        mainView.registerCells()
        mainView.rankingCollectionView.delegate = self
        mainView.rankingCollectionView.dataSource = self
    }
    
    private func updateTopThreePodium() {
        topThreeUsers.forEach { user in
            mainView.topThreePodium.configure(with: user)
        }
    }
    
    private func updateMyRanking() {
        guard let myRanking = self.myRanking else { return }
        mainView.myRankingScore.configure(with: myRanking)
    }
    
    private func showUserProfile(userId: String) {
            let viewModel = UserProfileViewModel(userId: userId, sport: currentUserSport())
            let userProfileVC = UserProfileViewController(viewModel: viewModel)
            navigationController?.pushViewController(userProfileVC, animated: true)
        }
        
        private func currentUserSport() -> Sports {
            guard let userId = KeychainService.get(key: Environment.userIdKey), !userId.isEmpty else {
                return .badminton
            }

            let key = "\(Environment.sportsCodeKeyPrefix).\(userId)"
            let rawValue = KeychainService.get(key: key)
            guard let rawValue,
                  let sport = Sports(rawValue: rawValue) else {
                return .badminton
            }

            return sport
        }
}

// MARK: - Extensions

extension RankingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rankings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingCell", for: indexPath) as? RankingCell else {
            return UICollectionViewCell()
        }
        let ranker = rankings[indexPath.item]
        cell.configure(with: ranker)
        return cell
    }
}

extension RankingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ranker = rankings[indexPath.item]
        input.send(.rankingUserTapped(userId: ranker.userId))
    }
}

extension RankingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 62)
    }
}

