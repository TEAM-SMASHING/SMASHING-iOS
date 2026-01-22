//
//  RankingCardView.swift
//  SMASHING
//
//  Created by 홍준범 on 1/15/26.
//

import UIKit
import Combine

import SnapKit
import Then

final class RankingCardView: BaseUIView {
    
    // MARK: - UI Components
    
    private let gradientLayer = CAGradientLayer().then {
        $0.colors = [UIColor.Background.overlay.cgColor, UIColor.Background.canvas.cgColor]
        $0.locations = [0.4, 0.9]
        $0.startPoint = CGPoint(x: 0.5, y: 0.0)
        $0.endPoint = CGPoint(x: 0.5, y: 1.0)
        $0.cornerRadius = 8
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 8
    }
    
    private let rankImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let tierImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let lpLabel = UILabel().then {
        $0.font = .pretendard(.captionXxsR)
        $0.textColor = .Text.tertiary
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        containerView.layer.addSublayer(gradientLayer)
        containerView.addSubviews(rankImage, tierImage, lpLabel)
        
        addSubviews(containerView)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        gradientLayer.frame = containerView.bounds
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        rankImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(8)
            $0.height.equalTo(16)
        }
        
        tierImage.snp.makeConstraints {
            $0.top.equalTo(rankImage.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        lpLabel.snp.makeConstraints {
            $0.top.equalTo(tierImage.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Public Methods
    
    func configure(rankImage: UIImage?, tierCode: String, lp: Int) {
        self.rankImage.image = rankImage
        self.tierImage.image = Tier.from(tierCode: tierCode)?.badge
        lpLabel.text = "\(lp) LP"
        
        // 1등은 tierImage 가 더 큼
        if rankImage == .icRank1 {
            self.tierImage.snp.remakeConstraints {
                $0.top.equalTo(self.rankImage.snp.bottom).offset(8)
                $0.centerX.equalToSuperview()
                $0.size.equalTo(60)
            }
            self.rankImage.snp.makeConstraints {
                $0.top.equalToSuperview().inset(12)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(8)
                $0.height.equalTo(16)
            }
        } else {
            self.tierImage.snp.remakeConstraints {
                $0.top.equalTo(self.rankImage.snp.bottom).offset(8)
                $0.centerX.equalToSuperview()
                $0.size.equalTo(40)
            }
            self.rankImage.snp.makeConstraints {
                $0.top.equalToSuperview().inset(12)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(8)
                $0.height.equalTo(12)
            }
        }
    }
}
