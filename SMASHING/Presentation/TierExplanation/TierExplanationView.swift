//
//  File.swift
//  SMASHING
//
//  Created by 이승준 on 1/16/26.
//

import UIKit

import SnapKit
import Then

final class TierExplanationView: BaseUIView {
    
    //MARK: - Properties
    
    var dismissAction: (() -> Void)?
    
    //MARK: - UI Components
    
    private lazy var navigationBar = CustomNavigationBar(title: "티어 설명").then {
        $0.setRightButton(image: UIImage.icCloseLg, action: dismissAction ?? {})
        $0.setLeftButtonHidden(true)
    }
    
    private let imageView = UIImageView().then {
        $0.backgroundColor = .darkGray
    }
    
    private let tierLabel = UILabel().then {
        $0.text = "티어 설명"
        $0.font = .pretendard(.titleXlSb)
        $0.textColor = .Text.primary
        $0.textAlignment = .center
    }
    
    private let detailStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }
    
    private let topPercentLabel = PaddingLabel().then {
        $0.font = .pretendard(.textSmM)
        $0.textAlignment = .center
        $0.textColor = .Text.primary
        $0.backgroundColor = .Background.surface
        $0.edgeInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.text = "상위 10%"
    }
    
    private let actualTierLabel = PaddingLabel().then {
        $0.font = .pretendard(.textSmM)
        $0.textAlignment = .center
        $0.textColor = .Text.primary
        $0.backgroundColor = .Background.surface
        $0.edgeInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.text = "실제 기준 5부"
    }
    
    let tierCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.register(TierChipCell.self, forCellWithReuseIdentifier: TierChipCell.reuseIdentifier)
        
        return collection
    }()
    
    private let recomandationLabel = UILabel().then {
        $0.text = "승급을 위해 아래의 기술들을 연마해보세요"
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.primary
    }
    
    let tierExplanationCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 12
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection
            .register(SkillExplanationCell.self, forCellWithReuseIdentifier: SkillExplanationCell.reuseIdentifier)
        
        return collection
    }()
    
    //MARK: - Lifecycle
    
    override func setUI() {
        addSubviews(navigationBar, imageView, tierLabel, detailStack, tierCollectionView,
                    recomandationLabel, tierExplanationCollectionView)
        
        detailStack.addArrangedSubviews(topPercentLabel, actualTierLabel)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        tierLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        detailStack.snp.makeConstraints {
            $0.top.equalTo(tierLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        tierCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(detailStack.snp.bottom).offset(28)
            $0.height.equalTo(40)
        }
        
        recomandationLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(tierCollectionView.snp.bottom).offset(20)
        }
        
        tierExplanationCollectionView.snp.makeConstraints {
            $0.top.equalTo(recomandationLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func configure(oreTier: OreTier, sports: Sports) {
        tierLabel.text = oreTier.rawValue
        topPercentLabel.text = oreTier.percentage
        actualTierLabel.text = oreTier.actualTier(sports: sports)
    }
}
