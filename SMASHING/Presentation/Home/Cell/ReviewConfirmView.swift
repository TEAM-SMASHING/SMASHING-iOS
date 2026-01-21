//
//  ReviewConfirmView.swift
//  SMASHING
//
//  Created by 홍준범 on 1/22/26.
//

import UIKit
import Combine

import SnapKit
import Then

final class ReviewConfirmView: BaseUIView {
    private let navigationBar = CustomNavigationBar(title: "후기")
    
    private let textLabel = UILabel().then {
        $0.text = "밤이달이님이 보낸 후기가 도착했어요"
        $0.font = .pretendard(.titleXlSb)
        $0.numberOfLines = 2
        $0.textColor = .Text.primary
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 8
    }
    
    private let fingerImageView = UIImageView().then {
        $0.image = .icThumbsUp
        $0.contentMode = .scaleAspectFit
    }
    
    private let fingerLabel = UILabel().then {
        $0.text = "최고예요"
        $0.font = .pretendard(.titleXlM)
        $0.textColor = .Text.primary
    }
    
    private let reviewTextLabel = UILabel().then {
        $0.text = "요즘은 두바이 쫀득쿠키가 유행이에요 맛있어요 근데 너무 비싸요 그치만 그 값을 해요 근데 비싸요 \n날씨가 너무 추워요 내일 눈이 와여 오늘은 새해에요 왜 벌써 2026인거죠 올해 태어난 사람은 2105년에 팔순이에요"
        $0.numberOfLines = 5
        $0.font = .pretendard(.textMdM)
        $0.textColor = .Text.secondary
    }
    
    private let rapidchips = RapidReviewChipContainer()
    
    private let confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = .pretendard(.textMdSb)
        $0.titleLabel?.textColor = .Button.textPrimaryActive
        $0.backgroundColor = .Button.backgroundPrimaryActive
    }
    
    override func setUI() {
        containerView.addSubviews(fingerImageView, fingerLabel, reviewTextLabel, rapidchips)
        
        addSubviews(navigationBar, textLabel, containerView, confirmButton)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        textLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.equalToSuperview().inset(16)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(textLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(461)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(52)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
