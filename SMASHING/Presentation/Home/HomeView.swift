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
    
    private var compositionalLayout: UICollectionViewCompositionalLayout = {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let sectionType = HomeViewLayout(rawValue: sectionIndex) else {
                return HomeViewLayout.matching.section
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
        super.init(frame: .zero, collectionViewLayout: self.compositionalLayout)
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
}
