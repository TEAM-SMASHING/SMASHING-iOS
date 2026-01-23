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
    private var dropDownView: HomeDropDownView?
    private var dropDownTopConstraint: Constraint?
    private var isDropDownVisible = false
    private var dropDownBackgroundView: UIView?
    private var hasNewNotification: Bool = false
    
    override func loadView() {
        view = homeView
    }
    
    private let viewModel: HomeViewModel
    private let input = PassthroughSubject<HomeViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let myProfileViewModel: any MyProfileViewModelProtocol
    private let myProfileInput = PassthroughSubject<MyProfileViewModel.Input, Never>()
    private var latestMyProfile: MyProfileListResponse?
    
    private var recentMatching: [MatchingConfirmedGameDTO] = []
    private var recommendedUsers: [RecommendedUserDTO] = []
    private var rankings: [RankingUserDTO] = []
    private var myNickname: String {
        return KeychainService.get(key: Environment.nicknameKey) ?? ""
    }
    
    private var myUserId: String {
        return KeychainService.get(key: Environment.userIdKey) ?? ""
    }
    
    private var myRegion: String {
        return KeychainService.get(key: Environment.regionKey) ?? ""
    }
    
    private var mySportCode: String {
        return KeychainService.get(key: Environment.sportsCodeKeyPrefix) ?? ""
    }
    
    init(viewModel: HomeViewModel, myProfileViewModel: any MyProfileViewModelProtocol) {
        self.viewModel = viewModel
        self.myProfileViewModel = myProfileViewModel
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
        myProfileInput.send(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.send(.viewWillAppear)
        myProfileInput.send(.viewWillAppear)
        homeView.reloadSections(IndexSet(integer: HomeViewLayout.navigationBar.rawValue))
    }
    
    private func setCollectionView() {
        homeView.delegate = self
        homeView.dataSource = self
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output.recentMatchings
            .receive(on: DispatchQueue.main)
            .sink { [weak self] matching in
                self?.recentMatching = matching
                self?.homeView.reloadSections(IndexSet(integer: HomeViewLayout.matching.rawValue))
            }
            .store(in: &cancellables)
        
        output.recommendedUsers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users in
                self?.recommendedUsers = users
                self?.homeView.setRecommendedUserEmpty(users.isEmpty)
                self?.homeView.reloadSections(IndexSet(integer: HomeViewLayout.recommendedUser.rawValue))
            }
            .store(in: &cancellables)
        
        output.rankings
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rankings in
                self?.rankings = rankings
                self?.homeView.reloadSections(IndexSet(integer: HomeViewLayout.ranking.rawValue))
            }
            .store(in: &cancellables)
        
        output.navToMatchResultConfirm
            .receive(on: DispatchQueue.main)
            .sink { [weak self] gameData in
                self?.navigateToMatchResultConfirm(gameData: gameData)
            }
            .store(in: &cancellables)
        
        output.sseNotificationTriggered
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.hasNewNotification = true
                self.homeView.reloadSections(IndexSet(integer: HomeViewLayout.navigationBar.rawValue))
            }
            .store(in: &cancellables)

        let myProfileOutput = myProfileViewModel.transform(input: myProfileInput.eraseToAnyPublisher())
        myProfileOutput.myProfileFetched
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.latestMyProfile = response
                self?.dropDownView?.configure(profile: response)
            }
            .store(in: &cancellables)
    }
    
    private func navigateToMatchResultConfirm(gameData: MatchingConfirmedGameDTO) {
        guard let submissionId = gameData.latestSubmissionId else { return }
        let viewModel = MatchResultConfirmViewModel(
            gameData: gameData,
            submissionId: submissionId,
            myUserId: myUserId
        )
        let vc = MatchResultConfirmViewController(viewModel: viewModel)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
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
            return recommendedUsers.isEmpty ? 1 : recommendedUsers.count
        case .ranking:
            return rankings.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = HomeViewLayout(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch sectionType {
        case .navigationBar:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeNavigationBarCell.reuseIdentifier, for: indexPath) as? HomeNavigationBarCell else { return UICollectionViewCell() }
            cell.configure(region: myRegion)
            cell.newNotification(hasNew: self.hasNewNotification)
            cell.onRegionButtonTapped = { [weak self] in
                self?.input.send(.regionTapped)
            }
            cell.onSportsAndTierTapped = { [weak self] in
                self?.toggleDropDown()
            }
            return cell
        case .matching:
            if recentMatching.isEmpty {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyMatchingCell.reuseIdentifier, for: indexPath) as? EmptyMatchingCell else { return UICollectionViewCell() }
                cell.onExploreButtonTapped = { [weak self] in
                    self?.input.send(.emptyButtonTapped)
                    print("매칭 탐색하러가기")
                }
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchingCell.reuseIdentifier, for: indexPath) as? MatchingCell else { return UICollectionViewCell() }
                let matching = recentMatching[indexPath.item]
                cell.configure(with: matching, myNickname: myNickname, myUserId: myUserId)
                cell.onWriteResultButtonTapped = { [weak self] in
                    guard let self else { return }
                    let isMySubmission = matching.latestSubmitterId == self.myUserId
                    let canConfirm = matching.resultStatus.canConfirm(isMySubmission: isMySubmission)
                    if canConfirm {
                        // 상대방이 제출한 결과 확인 플로우
                        self.input.send(.matchingResultConfirmButtonTapped(matching))
                    } else {
                        // 결과 작성 플로우
                        self.input.send(.matchingResultCreateButtonTapped(matching))
                    }
                }
                return cell
            }
            
        case .recommendedUser:
            
            if recommendedUsers.isEmpty {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyRecommendedUserCell.reuseIdentifier, for: indexPath) as? EmptyRecommendedUserCell else {
                    return UICollectionViewCell()
                }
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecomendedUserCell.reuseIdentifier, for: indexPath) as? RecomendedUserCell else { return UICollectionViewCell() }
                let user = recommendedUsers[indexPath.item]
                cell.configure(with: user)
                return cell
            }
            
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
            
            header.configure(title: "\(myNickname)님,", subTitle: "곧 다가오는 매칭이 있어요")
            header.onMoreButtonTapped = { [weak self] in
                self?.input.send(.matchingSeeAllTapped)
            }
            return header
        case .recommendedUser:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CommonSectionHeader.reuseIdentifier, for: indexPath) as? CommonSectionHeader else {
                return UICollectionReusableView()
            }
            header.configure(title: "\(myNickname)님을 위한 추천", showInfoButton: true)
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

// MARK: - DropDown

private extension HomeViewController {
    func toggleDropDown() {
        if isDropDownVisible {
            hideDropDown()
        } else {
            showDropDown()
        }
    }

    func showDropDown() {
        if dropDownView == nil {
            let backgroundView = UIView()
            backgroundView.backgroundColor = .Background.dimmed
            backgroundView.alpha = 0
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dropDownBackgroundTapped))
            backgroundView.addGestureRecognizer(tapGesture)
            view.addSubview(backgroundView)
            backgroundView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            dropDownBackgroundView = backgroundView

            let dropDown = HomeDropDownView()
            dropDown.onRegionButtonTapped = { [weak self] in
                self?.input.send(.regionTapped)
            }
            dropDown.onSportsCellTapped = { [weak self] sport in
                self?.myProfileInput.send(.sportsCellTapped(sport))
            }
            dropDown.onSportsAndTierTapped = { [weak self] in
                self?.hideDropDown()
            }
            view.addSubview(dropDown)
            dropDown.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(373)
                $0.bottom.equalToSuperview()
                dropDownTopConstraint = $0.top.equalToSuperview().offset(-view.bounds.height).constraint
            }
            dropDownView = dropDown

            UIView.animate(withDuration: 0.2) {
                backgroundView.alpha = 1
            }
        }
        if let profile = latestMyProfile {
            dropDownView?.configure(profile: profile)
        }

        view.layoutIfNeeded()
        dropDownTopConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.isDropDownVisible = true
        })
    }

    func hideDropDown() {
        guard let dropDownView else { return }
        dropDownTopConstraint?.update(offset: -view.bounds.height)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            self?.dropDownBackgroundView?.alpha = 0
        }, completion: { [weak self] _ in
            self?.isDropDownVisible = false
            dropDownView.removeFromSuperview()
            self?.dropDownView = nil
            self?.dropDownBackgroundView?.removeFromSuperview()
            self?.dropDownBackgroundView = nil
        })
    }
}

@objc private extension HomeViewController {
    func dropDownBackgroundTapped() {
        hideDropDown()
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sectionType = HomeViewLayout(rawValue: indexPath.section) else { return }
        switch sectionType {
        case .recommendedUser:
            let user = recommendedUsers[indexPath.row]
            input.send(.recommendedUserTapped(userId: user.userId))
        case .ranking:
            let ranker = rankings[indexPath.row]
            input.send(.rankingUserTapped(userId: ranker.userId))
        default:
            break
        }
    }
}

// MARK: Header Button
extension HomeViewController {
    private func showRecommendedUserInfo() {
        print("유저 추천 인포 탭")
        print("\(myRegion)")
        print("\(myNickname)")
        print("\(myUserId)")
        print("\(mySportCode)")
    }
    
    private func showMore() {
        input.send(.rankingSeeAllTapped)
    }
}
