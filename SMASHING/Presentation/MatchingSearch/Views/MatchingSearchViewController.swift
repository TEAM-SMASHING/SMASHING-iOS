//
//  MatchingSearchViewController.swift
//  SMASHING
//
//  Created by JIN on 1/6/26.
//

import UIKit
import Combine

import SnapKit
import Then

final class MatchingSearchViewController: BaseViewController {

    //MARK: - UIComponents

    private let matchingSearchView = MatchingSearchView()

    //MARK: - Properties

    private let viewModel: MatchingSearchViewModel
    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<MatchingSearchViewModel.Input, Never>()

    private var userList: [MatchingSearchUserProfileDTO] = []
    var onSearchTapped: (() -> Void)?
    var onUserSelected: ((String) -> Void)?
    var onRegionTapped: (() -> Void)?

    private let userProfileService = UserProfileService()

    private var myRegion: String {
        return UserDefaults.standard.string(forKey: UserDefaultKey.region) ?? ""
    }

    // MARK: - Init

    init() {
        self.viewModel = MatchingSearchViewModel(service: MatchingSearchService())
        super.init(nibName: nil, bundle: nil)
    }

    init(viewModel: any MatchingSearchViewModelProtocol) {
        self.viewModel = viewModel as! MatchingSearchViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        view = matchingSearchView
        super.viewDidLoad()
        setupCollectionView()
        setupHeaderActions()
        updateRegionHeader()
        bind()
        input.send(.viewDidLoad)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.send(.refresh)
        updateRegionHeader()
    }

    // MARK: - Bind

    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output.userList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users in
                guard let self else { return }
                self.userList = users
                self.matchingSearchView.collectionView.reloadData()
            }
            .store(in: &cancellables)

        output.isLoading
            .receive(on: DispatchQueue.main)
            .sink { _ in }
            .store(in: &cancellables)

        output.errorMessage
            .receive(on: DispatchQueue.main)
            .sink { message in
                print("Error: \(message)")
            }
            .store(in: &cancellables)

        output.navigateToUserProfile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userId in
                guard let self else { return }
                self.showUserProfile(userId: userId)
            }
            .store(in: &cancellables)

        matchingSearchView.collectionView.reachedBottomPublisher
            .sink { [weak self] in
                self?.input.send(.loadMore)
            }
            .store(in: &cancellables)
    }

    // MARK: - Setup Methods

    private func setupCollectionView() {
        matchingSearchView.collectionView.delegate = self
        matchingSearchView.collectionView.dataSource = self
    }

    private func setupHeaderActions() {
        matchingSearchView.headerView.onSearchTapped = { [weak self] in
            self?.showSearchResult()
        }

        matchingSearchView.headerView.onTierFilterTapped = { [weak self] in
            self?.presentTierFilterBottomSheet()
        }

        matchingSearchView.headerView.onGenderFilterTapped = { [weak self] in
            self?.presentGenderFilterBottomSheet()
        }

        matchingSearchView.headerView.onTierFilterReset = { [weak self] in
            self?.input.send(.tierFilterChanged(nil))
        }

        matchingSearchView.headerView.onGenderFilterReset = { [weak self] in
            self?.input.send(.genderFilterChanged(nil))
        }

        matchingSearchView.headerView.onRegionTapped = { [weak self] in
            self?.showRegionSelection()
        }
    }

    private func updateRegionHeader() {
        matchingSearchView.headerView.configure(region: myRegion)
    }

    // MARK: - Filter Actions

    private func presentTierFilterBottomSheet() {
        let tierFilterVC = TierFilterBottomSheetViewController()
        tierFilterVC.onTierSelected = { [weak self] tier in
            guard let self else { return }
            self.matchingSearchView.headerView.updateTierFilterButton(
                with: tier.simpleDisplayName
            )
            self.input.send(
                .tierFilterChanged(tier.groupCode)
            )
        }

        if let sheet = tierFilterVC.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { _ in
                return 500
            }
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = true
        }

        present(tierFilterVC, animated: true)
    }

    private func presentGenderFilterBottomSheet() {
        let genderFilterVC = GenderFilterBottomSheetViewController()
        genderFilterVC.onGenderSelected = { [weak self] genderName in
            guard let self else { return }
            self.matchingSearchView.headerView.updateGenderFilterButton(
                with: genderName
            )
            let gender: Gender? = {
                switch genderName {
                case "남성": return .male
                case "여성": return .female
                default: return nil
                }
            }()
            self.input.send(.genderFilterChanged(gender))
        }

        if let sheet = genderFilterVC.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { _ in
                return 282
            }
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = true
        }

        present(genderFilterVC, animated: true)
    }

    // MARK: - Navigation Methods

    private func showSearchResult() {
        let searchVC = SearchResultViewController()
        NavigationManager.shared.push(searchVC, hidesBottomBar: true)
    }

    private func showUserProfile(userId: String) {
        let sport = KeychainUserSportProvider().currentSport()
        let viewModel = UserProfileViewModel(userId: userId, sport: sport)
        let userProfileVC = UserProfileViewController(viewModel: viewModel)

        viewModel.output.navToMatchManage
            .receive(on: DispatchQueue.main)
            .sink { _ in
                NavigationManager.shared.navigateToMatchManageSentAndRefresh()
            }
            .store(in: &cancellables)

        NavigationManager.shared.push(userProfileVC)
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
}

//MARK: - DataSource

extension MatchingSearchViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return self.userList.count
        }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MatchingSearchCell.reuseIdentifier,
            for: indexPath
        ) as? MatchingSearchCell else {
            return UICollectionViewCell()
        }

        let user = self.userList[indexPath.row]
        cell.configure(
            nickname: user.nickname,
            gender: user.gender,
            tierCode: user.tierCode,
            wins: user.wins,
            losses: user.losses,
            reviews: user.reviews
        )
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MatchingSearchViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let user = userList[indexPath.row]
        input.send(.userCellTapped(user.userID))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MatchingSearchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (collectionView.frame.width - 43) / 2
        let height: CGFloat = 203
        return CGSize(width: width, height: height)
    }
}
