//
//  WinnerDropDown.swift
//  SMASHING
//
//  Created by 홍준범 on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class WinnerDropDown: UIButton {
    private let players = ["밤이달이", "와쿠와쿠"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .Background.surface
        layer.cornerRadius = 8
        clipsToBounds = true
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.backgroundColor = .Background.surface
        $0.isUserInteractionEnabled = false
    }
    
    private let label = UILabel().then {
        $0.text = "승자 선택"
        $0.textColor = .Text.disabled
        $0.setPretendard(.textSmM)
        $0.textAlignment = .center
    }
    
    private let chevronImageView = UIImageView().then {
        $0.image = .icArrowDown.withRenderingMode(.alwaysTemplate)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .Text.disabled
    }
    
    private func setUI() {
        stackView.addArrangedSubviews(label, chevronImageView)
        
        addSubviews(stackView)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(45)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
    
    func updateSelectedWinner(_ winner: String) {
        label.text = winner
        label.textColor = .Text.primary
    }
}

import SwiftUI
@available(iOS 18.0, *)
#Preview {
    WinnerDropDown()
}
