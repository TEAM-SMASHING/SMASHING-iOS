//
//  MatchingSearchViewController.swift
//  SMASHING
//
//  Created by JIN on 1/6/26.
//

import UIKit

import SnapKit
import Then

final class MatchingSearchViewController: BaseViewController {

    //MARK: - UIComponents

    private let matchingSearchView = MatchingSearchView()

    //MARK: - Properties

    private var matches: [MatchingSearchMockData] = []

    // MARK: - Lifecycle

    override func loadView() {
        view = matchingSearchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupHeaderActions()
        loadMockData()
    }

    // MARK: - Setup Methods

    private func setupCollectionView() {
        matchingSearchView.collectionView.delegate = self
        matchingSearchView.collectionView.dataSource = self
    }

    private func setupHeaderActions() {
        matchingSearchView.headerView.onSearchTapped = { [weak self] in
            self?.navigateToSearch()
        }

        matchingSearchView.headerView.onTierFilterTapped = { [weak self] in
            self?.presentTierFilterBottomSheet()
        }

        matchingSearchView.headerView.onGenderFilterTapped = { [weak self] in
            self?.presentGenderFilterBottomSheet()
        }
    }

    // MARK: - Navigation

    private func navigateToSearch() {
        let searchVC = SearchResultViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }

    // MARK: - Filter Actions

    private func presentTierFilterBottomSheet() {
        let tierFilterVC = TierFilterBottomSheetViewController()
        tierFilterVC.onTierSelected = { [weak self] tier in
            self?.matchingSearchView.headerView.updateTierFilterButton(with: tier.simpleDisplayName)
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
            self?.matchingSearchView.headerView.updateGenderFilterButton(with: genderName)
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
        return self.matches.count
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

        let match = self.matches[indexPath.row]
        cell.configure(
            nickname: match.nickname,
            gender: match.gender,
            tierId: match.tierId,
            wins: match.wins,
            losses: match.losses,
            reviews: match.reviewCount
        )
        return cell
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

//MARK: - Data

extension MatchingSearchViewController {

    private func loadMockData() {
        self.matches = [
            MatchingSearchMockData(
                userId: "0USER000111222",
                nickname: "윤서",
                gender: "FEMALE",
                tierId: 3,
                wins: 12,
                losses: 7,
                reviewCount: 5
            ),
            MatchingSearchMockData(
                userId: "0USER000111223",
                nickname: "민준",
                gender: "MALE",
                tierId: 5,
                wins: 45,
                losses: 12,
                reviewCount: 15
            ),
            MatchingSearchMockData(
                userId: "0USER000111224",
                nickname: "지우",
                gender: "FEMALE",
                tierId: 2,
                wins: 8,
                losses: 10,
                reviewCount: 3
            ),
            MatchingSearchMockData(
                userId: "0USER000111225",
                nickname: "서준",
                gender: "MALE",
                tierId: 10,
                wins: 78,
                losses: 34,
                reviewCount: 22
            ),
            MatchingSearchMockData(
                userId: "0USER000111226",
                nickname: "하은",
                gender: "FEMALE",
                tierId: 7,
                wins: 56,
                losses: 28,
                reviewCount: 18
            ),
            MatchingSearchMockData(
                userId: "0USER000111227",
                nickname: "도윤",
                gender: "MALE",
                tierId: 16,
                wins: 120,
                losses: 45,
                reviewCount: 35
            ),
            MatchingSearchMockData(
                userId: "0USER000111228",
                nickname: "수아",
                gender: "FEMALE",
                tierId: 1,
                wins: 5,
                losses: 15,
                reviewCount: 2
            ),
            MatchingSearchMockData(
                userId: "0USER000111229",
                nickname: "예준",
                gender: "MALE",
                tierId: 17,
                wins: 156,
                losses: 52,
                reviewCount: 48
            ),
            MatchingSearchMockData(
                userId: "0USER000111230",
                nickname: "시우",
                gender: "MALE",
                tierId: 4,
                wins: 23,
                losses: 18,
                reviewCount: 8
            ),
            MatchingSearchMockData(
                userId: "0USER000111231",
                nickname: "아린",
                gender: "FEMALE",
                tierId: 13,
                wins: 89,
                losses: 41,
                reviewCount: 28
            ),
            MatchingSearchMockData(
                userId: "0USER000111232",
                nickname: "준우",
                gender: "MALE",
                tierId: 8,
                wins: 67,
                losses: 30,
                reviewCount: 19
            ),
            MatchingSearchMockData(
                userId: "0USER000111233",
                nickname: "채원",
                gender: "FEMALE",
                tierId: 11,
                wins: 72,
                losses: 38,
                reviewCount: 24
            )
        ]
        self.matchingSearchView.collectionView.reloadData()
    }

}

// MARK: - Mock Data

struct MatchingSearchMockData {
    let userId: String
    let nickname: String
    let gender: String
    let tierId: Int
    let wins: Int
    let losses: Int
    let reviewCount: Int
}

