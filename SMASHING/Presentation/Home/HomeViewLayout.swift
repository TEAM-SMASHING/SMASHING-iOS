//
//  HomeViewLayout.swift
//  SMASHING
//
//  Created by 홍준범 on 1/11/26.
//

import UIKit

import SnapKit
import Then

enum HomeViewLayout: Int, CaseIterable {
    case navigationBar
    case matching
    case recommendedUser
    case ranking
}

extension HomeViewLayout {
    var defaultEdgeInsets: NSDirectionalEdgeInsets {
        get {
            NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        }
    }
    
    var itemSize: NSCollectionLayoutSize {
        switch self {
        case .navigationBar:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        case .matching:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(202))
        case .recommendedUser:
            return NSCollectionLayoutSize(widthDimension: .absolute(166), heightDimension: .absolute(187))
        case .ranking:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(62))
        }
    }
    
    var itemEdgeInsets: NSDirectionalEdgeInsets {
        defaultEdgeInsets
    }
    
    var groupSize: NSCollectionLayoutSize {
        switch self {
        case .navigationBar:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        case .matching:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(218))
        case .recommendedUser:
            return NSCollectionLayoutSize(widthDimension: .absolute(166), heightDimension: .absolute(187))
        case .ranking:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(62))
        }
    }
    
    var groupEdgeInsets: NSDirectionalEdgeInsets {
        defaultEdgeInsets
    }
    
    var headerSize: NSCollectionLayoutSize? {
        switch self {
        case .matching:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(65))
        case .recommendedUser:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(27))
        case .ranking:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(27))
        default:
            return nil
        }
    }
    
    var header: NSCollectionLayoutBoundarySupplementaryItem? {
        guard let headerSize = self.headerSize else { return nil }
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    
    var headerEdgeInsets: NSDirectionalEdgeInsets {
        return defaultEdgeInsets
    }
    
    var sectionBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior {
        switch self {
        case .navigationBar:
            return .none
        case .matching:
            return .none
        case .recommendedUser:
            return .continuous //가로 스크롤
        case .ranking:
            return .none
        }
    }
    
    var sectionEdgeInsets: NSDirectionalEdgeInsets {
        switch self {
        case .navigationBar:
            return NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)
        case .matching:
            return NSDirectionalEdgeInsets(top: 28, leading: 16, bottom: 40, trailing: 16)
        case .recommendedUser:
            return NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 40, trailing: 0)
        case .ranking:
            return NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16)
        }
    }
    
    var section: NSCollectionLayoutSection {
        return self.createSection()
    }
    
    private func createSection() -> NSCollectionLayoutSection {
        var supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
        
        let item = NSCollectionLayoutItem(layoutSize: self.itemSize)
        item.contentInsets = self.itemEdgeInsets
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: self.groupSize, subitems: [item])
        group.contentInsets = self.groupEdgeInsets
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = self.sectionEdgeInsets
        
        section.orthogonalScrollingBehavior = self.sectionBehavior
        
        switch self {
        case .recommendedUser:
            section.interGroupSpacing = 12
        case .ranking:
            section.interGroupSpacing = 12
        default:
            break
        }
        
        if let header = self.header {
            header.contentInsets = self.headerEdgeInsets
            supplementaryItems.append(header)
        }
        
        section.boundarySupplementaryItems = supplementaryItems
        
        return section
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout(section: self.section)
        return layout
    }
}
