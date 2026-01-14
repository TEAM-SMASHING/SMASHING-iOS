//
//  RecomendedUserCell.swift
//  SMASHING
//
//  Created by 홍준범 on 1/11/26.
//

import UIKit

import Then
import SnapKit

final class RecomendedUserCell: BaseUICollectionViewCell, ReuseIdentifiable {
    
    private let containerView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 8
    }
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(systemName: "circle.fill")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
    }
    
    private let nickNameStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    private let nickName = UILabel().then {
        $0.text = "NickName"
        $0.setPretendard(.textSmM)
        $0.textColor = .Text.primary
        $0.textAlignment = .center
    }
    
    private let genderImageView = UIImageView().then {
        $0.image = .icWomanSm
        $0.contentMode = .scaleAspectFit
    }
    
    private let tierImage = UIImageView().then {
        $0.image = .tierGoldStage1
        $0.contentMode = .scaleAspectFit
    }
    
    private let recordStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    
    private let recordLabel = UILabel().then {
        $0.text = "기록"
        $0.setPretendard(.captionXsM)
        $0.textColor = .Text.tertiary
        $0.textAlignment = .left
    }
    
    private let winLoseLabel = UILabel().then {
        $0.text = "0승 0패"
        $0.setPretendard(.textSmM)
        $0.textColor = .Text.secondary
        $0.textAlignment = .right
    }
    
    private let reviewStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    
    private let reviewLabel = UILabel().then {
        $0.text = "후기"
        $0.setPretendard(.captionXsM)
        $0.textColor = .Text.tertiary
        $0.textAlignment = .left
    }
    
    private let reviewCountLabel = UILabel().then {
        $0.text = "32"
        $0.setPretendard(.textSmM)
        $0.textColor = .Text.tertiary
        $0.textAlignment = .right
    }
    
    override func setUI() {
        nickNameStackView.addArrangedSubviews(nickName, genderImageView)
        
        recordStackView.addArrangedSubviews(recordLabel, winLoseLabel)
        
        reviewStackView.addArrangedSubviews(reviewLabel, reviewCountLabel)
        
        containerView.addSubviews(profileImageView, nickNameStackView, tierImage, recordStackView, reviewStackView)
        
        contentView.addSubview(containerView)
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).inset(16)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(52)
        }
        
        nickNameStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom)
            $0.centerX.equalTo(containerView).inset(13)
        }
        
        genderImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        tierImage.snp.makeConstraints {
            $0.top.equalTo(nickName.snp.bottom).offset(4)
            $0.horizontalEdges.equalTo(containerView).inset(49.5)
            $0.height.equalTo(24)
        }
        
        recordStackView.snp.makeConstraints {
            $0.top.equalTo(tierImage.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(containerView).inset(19.5)
        }
        
        reviewStackView.snp.makeConstraints {
            $0.top.equalTo(recordStackView.snp.bottom).offset(0)
            $0.horizontalEdges.equalTo(containerView).inset(19.5)
        }
    }
}

import SwiftUI
@available(iOS 18.0, *)
#Preview {
    RecomendedUserCell()
}

