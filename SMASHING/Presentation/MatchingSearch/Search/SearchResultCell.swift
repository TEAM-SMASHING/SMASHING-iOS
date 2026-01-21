//
//  SearchResultCell.swift
//  SMASHING
//
//  Created by JIN on 1/16/26.
//

import UIKit

import SnapKit
import Then

final class SearchResultCell: BaseUITableViewCell, ReuseIdentifiable {

    private let nicknameLabel = UILabel().then {
        $0.textColor = .Text.secondary
        $0.font = .pretendard(.textSmM)
        $0.numberOfLines = 1
    }
    
    override func setUI() {
        selectionStyle = .none
        backgroundColor = .Background.canvas
        addSubview(nicknameLabel)
    }
    
    override func setLayout() {
        nicknameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func configure(nickname: String) {
        nicknameLabel.text = nickname
    }

}
