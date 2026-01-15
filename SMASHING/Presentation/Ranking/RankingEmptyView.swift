//
//  RankingEmptyView.swift
//  SMASHING
//
//  Created by 홍준범 on 1/16/26.
//

import UIKit
import Combine

import SnapKit
import Then

final class RankingEmptyView: BaseUIView {
    // MARK: - Propertry
    
    private let emptyLabel = UILabel().then {
        $0.text = "아직 동네 랭커가 없어요"
        $0.textColor = .Text.tertiary
        $0.font = .pretendard(.textMdM)
        $0.textAlignment = .center
    }
    
    override func setUI() {
        addSubviews(emptyLabel)
    }
    
    override func setLayout() {
        emptyLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
