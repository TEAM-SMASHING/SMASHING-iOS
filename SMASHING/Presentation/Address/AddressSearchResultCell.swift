//
//  AddressSearchResultCell.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class AddressSearchResultCell: BaseUICollectionViewCell, ReuseIdentifiable {
    
    private let addressLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 1
    }
    
    override func setUI() {
        addSubview(addressLabel)
    }
    
    override func setLayout() {
        addressLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configure(address: String) {
        addressLabel.text = address
    }
}
