//
//  UICollectionView+.swift
//  SMASHING
//
//  Created by 이승준 on 1/5/26.
//

import UIKit

extension UICollectionView {
    
    func cellRegister<T: UICollectionViewCell & ReuseIdentifiable>(_ type: T.Type) {
        self.register(type.self, forCellWithReuseIdentifier: type.reuseIdentifier)
    }
    
    func headerRegister<T: UICollectionReusableView & ReuseIdentifiable>(_ type: T.Type) {
        self.register(
            type.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: type.reuseIdentifier
        )
    }
    
    func footerRegister<T: UICollectionReusableView & ReuseIdentifiable>(_ type: T.Type) {
        self.register(
            type.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: type.reuseIdentifier
        )
    }
    
    func dequeueReusableCell<T: UICollectionViewCell & ReuseIdentifiable>(
        _ cellType: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = self.dequeueReusableCell(
            withReuseIdentifier: cellType.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("No such cell")
        }
        return cell
    }
}
