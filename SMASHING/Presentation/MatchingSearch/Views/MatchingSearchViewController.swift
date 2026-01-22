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
    
    private let viewModel: any MatchingSearchViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<MatchingSearchViewModel.Input, Never>()
    
    private var userList: [MatchingSearchUserProfileDTO] = []
    var onSearchTapped: (() -> Void)?
    var onUserSelected: ((String) -> Void)?
    var onRegionTapped: (() -> Void)?
    
    private var myRegion: String {
        return KeychainService.get(key: Environment.regionKey) ?? ""
    }
    
    // MARK: - Init
    
    init(viewModel: any MatchingSearchViewModelProtocol) {
        self.viewModel = viewModel
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
                self.onUserSelected?(userId)
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
            self?.onSearchTapped?()
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
            self?.onRegionTapped?()
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
            sheet.detents = [.medium()]
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
        let height: CGFloat = 224
        return CGSize(width: width, height: height)
    }
}
