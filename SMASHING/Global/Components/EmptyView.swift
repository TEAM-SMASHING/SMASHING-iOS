//
//  EmptyView.swift
//  SMASHING
//
//  Created by 이승준 on 1/23/26.
//

import UIKit

import SnapKit
import Then

final class EmptyView: BaseUIView {
    
    // MARK: - UI Components
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(.subtitleLgSb)
        $0.textColor = .Text.secondary
        $0.textAlignment = .center
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = .pretendard(.textSmM)
        $0.textColor = .Text.tertiary
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }
    
    // MARK: - Configuration
    
    func configure(image: UIImage = .noResult, title: String, subtitle: String) {
        imageView.image = image
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    override func setUI() {
        addSubview(stackView)
        [imageView, titleLabel, subtitleLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
        
        stackView.setCustomSpacing(24, after: imageView)
    }
}

