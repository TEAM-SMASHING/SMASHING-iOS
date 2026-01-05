//
//  ViewController.swift
//  SMASHING
//
//  Created by 이승준 on 12/28/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    // 1. 프로퍼티 선언
        private let heroLabel = UILabel()
        private let titleLabel = UILabel()
        private let bodyLabel = UILabel()
        private let captionLabel = UILabel()

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            setupLayout()
            applyStyles()
        }
        
        private func setupLayout() {
            let stackView = UIStackView(arrangedSubviews: [heroLabel, titleLabel, bodyLabel, captionLabel])
            stackView.axis = .vertical
            stackView.spacing = 24
            
            view.addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(20)
            }
        }

        private func applyStyles() {
            // 2. 작성하신 확장 메서드(.setPretendard)를 사용하여 스타일 적용
            
            // 피그마: header/hero-B
            heroLabel.text = "Hero Header Text"
            heroLabel.setPretendard(.headerHeroB)
            
            // 피그마: title/2xl-Sb
            titleLabel.text = "2XL SemiBold Title"
            titleLabel.setPretendard(.title2xlSb)
            
            // 피그마: text/md-M
            bodyLabel.text = "이것은 본문 텍스트입니다. 설정하신 대로 150%의 줄 간격과 -1%의 자간이 자동으로 적용됩니다."
            bodyLabel.numberOfLines = 0
            bodyLabel.setPretendard(.textMdM)
            
            // 피그마: caption/xs-R
            captionLabel.text = "작은 캡션 텍스트입니다."
            captionLabel.textColor = .gray
            captionLabel.setPretendard(.captionXsR)
        }
}

import SwiftUI
@available(iOS 18.0, *)
#Preview {
    ViewController()
}
