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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
    }
    
    private func setCollectionView() {
        homeView.delegate = self
        homeView.dataSource = self
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        HomeViewLayout.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = HomeViewLayout(rawValue: section) else { return 0 }
        
        switch sectionType {
        case .matching:
            return 1
        case .recommendedUser:
            return 3
        case .ranking:
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = HomeViewLayout(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch sectionType {
        case .matching:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchingCell.reuseIdentifier, for: indexPath) as? MatchingCell else { return UICollectionViewCell() }
            return cell
            
        case .recommendedUser:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecomendedUserCell.reuseIdentifier, for: indexPath) as? RecomendedUserCell else { return UICollectionViewCell() }
            return cell
        case .ranking:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankingCell.reuseIdentifier, for: indexPath) as? RankingCell else { return UICollectionViewCell() }
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
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MatchingSectionHeader.identifier, for: indexPath) as? MatchingSectionHeader else {
                return UICollectionReusableView()
            }
            header.configure(title: "동현님", subTitle: "곧 다가오는 매칭이 있어요")
            return header
        case .recommendedUser:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CommonSectionHeader.identifier, for: indexPath) as? CommonSectionHeader else {
                return UICollectionReusableView()
            }
            header.configure(title: "주변 추천 유저")
            return header
        case .ranking:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CommonSectionHeader.identifier, for: indexPath) as? CommonSectionHeader else {
                return UICollectionReusableView()
            }
            header.configure(title: "우리 동네 랭커", showMoreButton: true)
            return header
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
}


import SwiftUI
@available(iOS 18.0, *)
#Preview {
    HomeViewController()
}
