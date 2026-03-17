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
    private var dropDownHeightConstraint: Constraint?
    private let rootView = UIView()
    private let homeView = HomeView().then {
        $0.backgroundColor = .Background.canvas
    }
    
    private var dropDownView: HomeDropDownView?

    private var dropDownTopConstraint: Constraint?
    private var isDropDownVisible = false
    private var dropDownBackgroundView: UIView?
    private var hasNewNotification: Bool = false

    private let dimView = UIView()
    
    private var isDropDownShown = false

    
    override func loadView() {
        view = rootView
    }
    
    private let viewModel: HomeViewModel
    private let input = PassthroughSubject<HomeViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let myProfileViewModel: MyProfileViewModel
    private let myProfileInput = PassthroughSubject<MyProfileViewModel.Input, Never>()
    private var latestMyProfile: MyProfileListResponse?

    private let userProfileService = UserProfileService()

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
        return UserDefaults.standard.string(forKey: UserDefaultKey.region) ?? ""
    }

    private var mySportCode: String {
        return KeychainService.get(key: Environment.sportsCodeKeyPrefix) ?? ""
    }

    // MARK: - Init

    init() {
        let regionService = RegionService()
        let matchingConfirmedService = MatchingConfirmedService()
        self.viewModel = HomeViewModel(regionService: regionService, matchingConfirmedService: matchingConfirmedService)
        self.myProfileViewModel = MyProfileViewModel(
            userProfileService: UserProfileService(),
            userReviewService: UserReviewService()
        )
        super.init(nibName: nil, bundle: nil)
    }

    init(viewModel: HomeViewModel, myProfileViewModel: any MyProfileViewModelProtocol) {
        self.viewModel = viewModel
        self.myProfileViewModel = myProfileViewModel as! MyProfileViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.backgroundColor = .Background.canvas
        rootView.addSubview(homeView)
        homeView.snp.makeConstraints {$0.edges.equalToSuperview()}
        
        setCollectionView()
        view.backgroundColor = .Background.canvas
        setupDimView()
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
    
    private func setupDimView() {
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        dimView.alpha = 0
        dimView.isHidden = true
        view.addSubview(dimView)
        dimView.snp.makeConstraints { $0.edges.equalToSuperview() }

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapDimView(_:)))
        dimView.addGestureRecognizer(tap)
        
        
    }
    
    @objc private func didTapDimView(_ gesture: UITapGestureRecognizer) {
        guard let dropDownView else {
            hideDropDown()
            return
        }
        let location = gesture.location(in: rootView)
        if dropDownView.frame.contains(location) {
            return
        }
        hideDropDown()
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

        // MARK: - Navigation Bindings (from HomeCoordinator)

        output.navToRegionSelection
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.showRegionSelection()
            }
            .store(in: &cancellables)

        output.navToMatchingManageTab
            .receive(on: DispatchQueue.main)
            .sink { _ in
                NavigationManager.shared.handleNotificationAction(.navRequestedMatchManage)
            }
            .store(in: &cancellables)

        output.navToMatchResultCreate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] gameData in
                self?.showMatchResultCreate(with: gameData)
            }
            .store(in: &cancellables)

        output.navToRanking
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.showRanking()
            }
            .store(in: &cancellables)

        output.navToSelectedUserProfile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userId in
                self?.showUserProfile(userId: userId)
            }
            .store(in: &cancellables)

        output.navToSearchUser
            .receive(on: DispatchQueue.main)
            .sink { _ in
                NavigationManager.shared.handleNotificationAction(.navSearchUser)
            }
            .store(in: &cancellables)

        output.navToNotification
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.showNotificationFlow()
            }
            .store(in: &cancellables)

        output.navToAddSports
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.showAddSports()
            }
            .store(in: &cancellables)

        let myProfileOutput = myProfileViewModel.transform(input: myProfileInput.eraseToAnyPublisher())
        myProfileOutput.myProfileFetched
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                guard let self else { return }
                self.latestMyProfile = response
                self.dropDownView?.configure(profile: response, myRegion: self.myRegion)
                self.homeView.reloadSections(IndexSet(integer: HomeViewLayout.navigationBar.rawValue))
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
        NavigationManager.shared.push(vc, hidesBottomBar: true)
    }
    
    // MARK: - Navigation Methods

    private func showMatchResultCreate(with gameData: MatchingConfirmedGameDTO) {
        let vm = MatchResultCreateViewModel(gameData: gameData, myUserId: myUserId, myNickname: myNickname)
        let vc = MatchResultCreateViewController(viewModel: vm)
        NavigationManager.shared.push(vc, hidesBottomBar: true)
    }

    private func showRanking() {
        let regionService = RegionService()
        let viewModel = RankingViewModel(regionService: regionService)
        let rankingVC = RankingViewController(viewModel: viewModel)
        NavigationManager.shared.push(rankingVC, hidesBottomBar: true)
    }

    private func showNotificationFlow() {
        let service = NotificationService()
        let viewModel = NotificationViewModel(service: service)
        let vc = NotificationListViewController(viewModel: viewModel)

        viewModel.output.navConfirmedMatchManage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                NavigationManager.shared.pop()
                NavigationManager.shared.handleNotificationAction(.navConfirmedMatchManage)
            }
            .store(in: &cancellables)

        viewModel.output.navRequestedMatchManage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                NavigationManager.shared.pop()
                NavigationManager.shared.handleNotificationAction(.navRequestedMatchManage)
            }
            .store(in: &cancellables)

        NavigationManager.shared.push(vc, hidesBottomBar: true)
    }

    private func showUserProfile(userId: String) {
        let viewModel = UserProfileViewModel(userId: userId, sport: currentUserSport())
        let userProfileVC = UserProfileViewController(viewModel: viewModel)

        viewModel.output.navToMatchManage
            .receive(on: DispatchQueue.main)
            .sink { _ in
                NavigationManager.shared.navigateToMatchManageSentAndRefresh()
            }
            .store(in: &cancellables)

        NavigationManager.shared.push(userProfileVC)
    }

    private func currentUserSport() -> Sports {
        guard let userId = KeychainService.get(key: Environment.userIdKey), !userId.isEmpty else {
            return .badminton
        }
        let key = "\(Environment.sportsCodeKeyPrefix).\(userId)"
        let rawValue = KeychainService.get(key: key)
        guard let rawValue, let sport = Sports(rawValue: rawValue) else {
            return .badminton
        }
        return sport
    }

    private func showRegionSelection() {
        let addressVC = AddressSearchViewController(mode: .changeRegion)
        addressVC.onAddressSelected = { [weak self] address in
            guard let self else { return }
            UserDefaults.standard.set(address, forKey: UserDefaultKey.region)
            self.userProfileService.updateRegion(region: address)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
                .store(in: &self.cancellables)
        }
        NavigationManager.shared.push(addressVC, hidesBottomBar: true)
    }

    private func showAddSports() {
        let addSportsVC = AddSportsViewController()
        NavigationManager.shared.push(addSportsVC, hidesBottomBar: true)
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

            cell.newNotification(hasNew: self.hasNewNotification)
            let region = myRegion
            let sportCode = latestMyProfile?.activeProfile.sportCode.rawValue
            let tierCode = latestMyProfile?.activeProfile.tierCode ?? ""
            
            cell.configure(region: myRegion, sportCode: sportCode, tierCode: tierCode)
            cell.onRegionButtonTapped = { [weak self] in
                self?.input.send(.regionTapped)
            }
            cell.onSportsAndTierTapped = { [weak self] in
                self?.toggleDropDown()
            }
            cell.onBellTapped = { [weak self] in
                self?.input.send(.notificationTapped)
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

extension HomeViewController {

    private func toggleDropDown() {
        isDropDownShown ? hideDropDown() : showDropDown()
    }

    private func showDropDown() {
        guard !isDropDownShown else { return }
        isDropDownShown = true

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            // 레이아웃 강제 반영
            self.homeView.layoutIfNeeded()
            self.rootView.layoutIfNeeded()

            let indexPath = IndexPath(item: 0, section: HomeViewLayout.navigationBar.rawValue)

            guard let attr = self.homeView.layoutAttributesForItem(at: indexPath) else {
                self.isDropDownShown = false
                return
            }

            let frameInRoot = self.homeView.convert(attr.frame, to: self.rootView)
            let topY = max(0, frameInRoot.minY - view.safeAreaInsets.top)

            if self.dropDownView == nil {
                let dd = HomeDropDownView()
                self.dropDownView = dd
                dd.onBellTapped = { [weak self] in
                    self?.hideDropDown()
                    self?.input.send(.notificationTapped)
                }
                
                if let profile = self.latestMyProfile {
                    dd.configure(profile: profile, myRegion: myRegion)
                }

                dd.onRegionButtonTapped = { [weak self] in
                    self?.hideDropDown()
                    self?.input.send(.regionTapped)
                }

                dd.onSportsAndTierTapped = { [weak self] in
                    self?.hideDropDown()
                }

                dd.onSportsCellTapped = { [weak self] sport in
                    guard let self else { return }
                    if let sport {
                        self.myProfileInput.send(.sportsCellTapped(sport))
                    } else {
                        self.input.send(.addSportsTapped)
                    }
                }

                dd.onAddSportsTapped = { [weak self] in
                    self?.hideDropDown()
                    self?.input.send(.addSportsTapped)
                }

                self.rootView.addSubview(self.dimView)
                self.rootView.addSubview(dd)

                self.dimView.snp.remakeConstraints { $0.edges.equalToSuperview() }

                dd.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview()
                    $0.top.equalToSuperview().offset(topY)
                    $0.height.equalTo(420)
                }

            } else {
                self.dropDownView?.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(topY)
                }
            }

            self.rootView.layoutIfNeeded()

            self.rootView.bringSubviewToFront(self.dimView)
            if let dd = self.dropDownView {
                self.rootView.bringSubviewToFront(dd)
            }

            // 애니메이션
            self.dimView.isHidden = false
            self.dimView.alpha = 0

            self.dropDownView?.alpha = 0
            self.dropDownView?.transform = CGAffineTransform(translationX: 0, y: -8)

            UIView.animate(withDuration: 0.22, delay: 0, options: [.curveEaseOut]) {
                self.dimView.alpha = 1
                self.dropDownView?.alpha = 1
                self.dropDownView?.transform = .identity
            }
        }
    }

    private func hideDropDown() {
        guard isDropDownShown else { return }
        isDropDownShown = false

        UIView.animate(withDuration: 0.18, delay: 0, options: [.curveEaseIn]) {
            self.dimView.alpha = 0
            self.dropDownView?.alpha = 0
            self.dropDownView?.transform = CGAffineTransform(translationX: 0, y: -8)
        } completion: { _ in
            self.dimView.isHidden = true
            self.dropDownView?.transform = .identity
        }
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
