//
//  BaseUICollectionViewCell.swift
//  SMASHING
//
//  Created by 이승준 on 12/29/25.
//

import UIKit

class BaseUICollectionViewCell: UICollectionViewCell {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setup() {
        setUI()
        setLayout()
        setAction()
    }
    
    func setUI() { }
    func setLayout() { }
    func setAction() { }
}
