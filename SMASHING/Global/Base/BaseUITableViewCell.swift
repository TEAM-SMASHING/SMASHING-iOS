//
//  BaseUITableViewCell.swift
//  SMASHING
//
//  Created by 이승준 on 12/29/25.
//

import UIKit

class BaseUITableViewCell: UITableViewCell {
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setLayout()
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
