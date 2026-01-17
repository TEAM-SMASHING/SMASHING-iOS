//
//  HomeViewController.swift
//  SMASHING
//
//  Created by 홍준범 on 1/11/26.
//

import UIKit
import Combine

import Then
import SnapKit

final class HomeViewController: BaseViewController {
    private let homeView = HomeView()
    
    override func loadView() {
        view = homeView
        
    }
    
    private let viewModel: HomeViewModel
    
    private let input = PassthroughSubject<HomeViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    //Data
//    private var recentMatching: RecentMatchingDTO?
    private var recommendedUsers: [RecommendedUserDTO] = []
    private var rankings: [RankingUserDTO] = []
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        view.backgroundColor = .Background.canvas
        bind()
        input.send(.viewDidLoad)
        
        _ = KeychainService.add(key: Environment.accessTokenKey, value: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIwUDZLRjZURFBUQ0ZSIiwidHlwZSI6IkFDQ0VTU19UT0tFTiIsInJvbGVzIjpbXSwiaWF0IjoxNzY4NTg5Mzg0LCJleHAiOjEyMDk3NzY4NTg5Mzg0fQ.VwumDSiP-4x5VoW-39UOj83Zc-XBsHJVdrngA5hmpl0")
    }
    
    private func setCollectionView() {
        homeView.delegate = self
        homeView.dataSource = self
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output.recommendedUsers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users in
                self?.recommendedUsers = users
                self?.homeView.reloadSections(IndexSet(integer: HomeViewLayout.recommendedUser.rawValue))
            }
            .store(in: &cancellables)
        
        output.rankings
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rankings in
                print("🟡 [HomeVC] rankings 바인딩: \(rankings.count)개")
                self?.rankings = rankings
                self?.homeView.reloadSections(IndexSet(integer: HomeViewLayout.ranking.rawValue))
            }
            .store(in: &cancellables)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        HomeViewLayout.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = HomeViewLayout(rawValue: section) else { return 0 }
        
        switch sectionType {
        case .navigationBar:
            return 1
        case .matching:
            return 1
        case .recommendedUser:
            return recommendedUsers.count
        case .ranking:
            return rankings.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = HomeViewLayout(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch sectionType {
        case .navigationBar:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeNavigationBarCell.reuseIdentifier, for: indexPath) as? HomeNavigationBarCell else { return UICollectionViewCell() }
            return cell
        case .matching:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchingCell.reuseIdentifier, for: indexPath) as? MatchingCell else { return UICollectionViewCell() }
            return cell
            
        case .recommendedUser:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecomendedUserCell.reuseIdentifier, for: indexPath) as? RecomendedUserCell else { return UICollectionViewCell() }
            let user = recommendedUsers[indexPath.item]
            cell.configure(with: user)
            return cell
        case .ranking:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankingCell.reuseIdentifier, for: indexPath) as? RankingCell else { return UICollectionViewCell() }
            let ranker = rankings[indexPath.item]
            cell.configure(with: ranker)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let sectionType = HomeViewLayout(rawValue: indexPath.section) else {
            return UICollectionReusableView()
        }
        
        switch sectionType {
        case .matching:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MatchingSectionHeader.reuseIdentifier, for: indexPath) as? MatchingSectionHeader else {
                return UICollectionReusableView()
            }
            header.configure(title: "동현님,", subTitle: "곧 다가오는 매칭이 있어요")
            return header
        case .recommendedUser:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CommonSectionHeader.reuseIdentifier, for: indexPath) as? CommonSectionHeader else {
                return UICollectionReusableView()
            }
            header.configure(title: "주변 추천 유저", showInfoButton: true)
            header.onInfoButtonTapped = { [weak self ] in
                self?.showRecommendedUserInfo()
            }
            return header
        case .ranking:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CommonSectionHeader.reuseIdentifier, for: indexPath) as? CommonSectionHeader else {
                return UICollectionReusableView()
            }
            header.configure(title: "우리 동네 랭커", showInfoButton: false, showMoreButton: true)
            header.onMoreButtonTapped = { [weak self] in
                self?.showMore()
            }
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
}

// MARK: Header Button
extension HomeViewController {
    private func showRecommendedUserInfo() {
        print("유저 추천 인포 탭")
    }
    
    private func showMore() {
        print("모두보기")
    }
}
