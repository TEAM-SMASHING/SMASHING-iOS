//
//  HomeView.swift
//  SMASHING
//
//  Created by 홍준범 on 1/11/26.
//

import Foundation
import UIKit

import Then
import SnapKit

final class HomeView: UICollectionView {
    
    private var isRecommendedUserEmpty: Bool = false
    
    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let sectionType = HomeViewLayout(rawValue: sectionIndex) else {
                return HomeViewLayout.matching.section
            }
            
            if sectionType == .recommendedUser, self?.isRecommendedUserEmpty == true {
                return HomeViewLayout.recommendedUserEmptySection
            }
            return sectionType.section
        }
    }()
    
    //    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    //        super.init(frame: .zero, collectionViewLayout: self.compositionalLayout)
    //
    //        register()
    //        setStyle()
    //    }
    //
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        setCollectionViewLayout(compositionalLayout, animated: false)
        register()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func register() {
        self.cellRegister(HomeNavigationBarCell.self)
        self.cellRegister(MatchingCell.self)
        self.cellRegister(RecomendedUserCell.self)
        self.cellRegister(RankingCell.self)
        self.cellRegister(EmptyMatchingCell.self)
        self.cellRegister(EmptyRecommendedUserCell.self)
        
        register(
            MatchingSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MatchingSectionHeader.reuseIdentifier
        )
        
        register(
            CommonSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CommonSectionHeader.reuseIdentifier
        )
    }
    
    private func setStyle() {
        backgroundColor = .white
    }
    
    func setRecommendedUserEmpty(_ isEmpty: Bool) {
        guard isRecommendedUserEmpty != isEmpty else { return }
        isRecommendedUserEmpty = isEmpty
        setCollectionViewLayout(compositionalLayout, animated: false)
    }
}
