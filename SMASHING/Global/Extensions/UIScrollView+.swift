//
//  UIScrollView+.swift
//  SMASHING
//
//  Created by 홍준범 on 1/14/26.
//

import UIKit
import Combine

extension UIScrollView {
    var reachedBottomPublisher: AnyPublisher<Void, Never> {
        return publisher(for: \.contentOffset)
            .map { [weak self] contentOffset -> Bool in
                guard let self = self else { return false }
                
                let offsetY = contentOffset.y
                let contentHeight = self.contentSize.height
                let height = self.frame.size.height
                
                return offsetY > contentHeight - height - 100
            }
            .removeDuplicates()
            .filter { $0 }
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
