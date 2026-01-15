//
//  RankingView.swift
//  SMASHING
//
//  Created by 홍준범 on 1/15/26.
//

import UIKit
import Combine

import SnapKit
import Then

final class RankingView: BaseUIView {
    
    // MARK: - Properties
    private let rankingEmptyView = RankingEmptyView()
    
    let navigationBar = CustomNavigationBar(title: "전체 랭킹")
    
    let topThreePodium = TopThreePodium()
    
    private let backgroundEffectView = UIView().then {
        $0.backgroundColor = .Tier.diamondBackground
        $0.layer.cornerRadius = 50
        $0.layer.shadowColor = UIColor(red: 27/255, green: 47/255, blue: 81/255, alpha: 1.0).cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.layer.shadowRadius = 100
        $0.layer.shadowOpacity = 1.0
        $0.layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Spread 효과를 위해 shadowPath 설정
        let spread: CGFloat = 100
        let rect = backgroundEffectView.bounds.insetBy(dx: -spread, dy: -spread)
        backgroundEffectView.layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: backgroundEffectView.layer.cornerRadius + spread).cgPath
    }
    
    private let collectionViewContainer = UIView().then {
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .Background.canvas
    }
    
    lazy var rankingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.layer.cornerRadius = 16
        return collectionView
    }()
    
    private let myRankingScore = myRankingScoreView()
    
    override func setUI() {
        collectionViewContainer.addSubview(rankingCollectionView)
        collectionViewContainer.addSubview(rankingEmptyView)
        
        addSubviews(backgroundEffectView, navigationBar, topThreePodium, collectionViewContainer, myRankingScore)
        
        rankingEmptyView.isHidden = true
    }
    
    override func setLayout() {
        backgroundEffectView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(10)
        }
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        topThreePodium.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        collectionViewContainer.snp.makeConstraints {
            $0.top.equalTo(topThreePodium.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(myRankingScore.snp.top)
            //            $0.bottom.equalToSuperview()
        }
        
        rankingCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        rankingEmptyView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        myRankingScore.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(88)
        }
    }
    
    func registerCells() {
        rankingCollectionView.register(RankingCell.self, forCellWithReuseIdentifier: RankingCell.reuseIdentifier)
    }
    
    func updateEmptyState(isEmpty: Bool) {
        rankingEmptyView.isHidden = !isEmpty
        rankingCollectionView.isHidden = isEmpty
    }
}
