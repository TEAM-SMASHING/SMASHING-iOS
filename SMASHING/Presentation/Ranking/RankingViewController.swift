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
        setDummyData()
        view.backgroundColor = .Background.canvas
        setCollectionView()
        
        mainView.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
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
        //        output.navigateToUserProfile
        //        output.navigateBack
    }
    
    private func setCollectionView() {
        mainView.registerCells()
        mainView.rankingCollectionView.delegate = self
        mainView.rankingCollectionView.dataSource = self
    }
    
    private func updateTopThreePodium() {
        guard topThreeUsers.count >= 3 else { return }
        
        let first = topThreeUsers[0]
        let second = topThreeUsers[1]
        let third = topThreeUsers[2]
        
        mainView.topThreePodium.configure(first: (nickname: first.nickname, profileImage: nil, tierImage: nil, lp: first.lp), second: (nickname: second.nickname, profileImage: nil, tierImage: nil, lp: second.lp), third: (nickname: third.nickname, profileImage: nil, tierImage: nil, lp: third.lp))
    }
    
    private func setDummyData() {
        mainView.topThreePodium.configure(
            first: (
                nickname: "밤이달이밤이달이밤이",
                profileImage: nil,
                tierImage: .bad,
                lp: 1430
            ),
            second: (
                nickname: "와구와구와구와구와구",
                profileImage: nil,
                tierImage: .good,
                lp: 1298
            ),
            third: (
                nickname: "스매싱고수스매싱고수",
                profileImage: nil,
                tierImage: .bad,
                lp: 1156
            )
        )
    }
    
    private func updateMyRanking() {
        guard let myRanking = self.myRanking else { return }
        mainView.myRankingScore.configure(with: myRanking)
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

