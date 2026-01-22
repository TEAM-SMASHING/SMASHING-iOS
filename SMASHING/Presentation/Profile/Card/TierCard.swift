//
//  TierCard.swift
//  SMASHING
//
//  Created by 이승준 on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class TierCard: BaseUIView {
    
    // MARK: - Properties
    
    var addAction: (() -> Void)?
    var tierDetailAction: (() -> Void)?
    var onSportsAction: ((Sports?) -> Void)?
    var selectedSports: [Sports] = [.badminton, .tableTennis, .tennis]
    
    // MARK: - UI Components
    
    private let containerView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private lazy var sportsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.minimumInteritemSpacing = 7
    }).then {
        $0.register(SportsButtonCell.self, forCellWithReuseIdentifier: SportsButtonCell.reuseIdentifier)
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var plusButton = UIButton().then {
        $0.setImage(.icPlus, for: .normal)
        $0.backgroundColor = .Background.overlay
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
    }
    
    private let tierImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let tierMark = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let progressBar = UIProgressView().then {
        $0.tintColor = .State.progressFill
        $0.backgroundColor = .State.progressTrack
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.progress = 0.4
    }
    
    private let tierBadge = UIImageView().then {
        $0.image = .tierGoldStage3
        $0.contentMode = .scaleAspectFit
    }
    
    private let lastLPLabel = UILabel().then {
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.primary
        $0.text = ""
    }
    
    private let lpLeft = UILabel().then {
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.tertiary
        $0.text = "LP 남았어요!"
    }
    
    private let lpLabel = UILabel().then {
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.tertiary
        $0.text = "LP"
    }
    
    private let totalLPLabel = UILabel().then {
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.primary
        $0.text = ""
    }
    
    private lazy var tierDetailButton = BlueCTAButton(label: "티어 설명").then {
        $0.addTarget(self, action: #selector(detailTapped), for: .touchUpInside)
    }
    
    override func setUI() {
        addSubview(containerView)
        containerView.addSubviews(sportsCollectionView, tierImage, tierMark,
                                  progressBar, tierBadge, lastLPLabel, lpLeft, lpLabel, totalLPLabel)
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        sportsCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        tierImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(sportsCollectionView.snp.bottom).offset(20)
            $0.size.equalTo(100)
        }
        
        progressBar.snp.makeConstraints {
            $0.top.equalTo(tierImage.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(8)
        }
        
        tierBadge.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(progressBar.snp.top).inset(-8)
            $0.height.equalTo(24)
            $0.width.equalTo(67)
        }
        
        lastLPLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalTo(progressBar.snp.bottom).offset(8)
        }
        
        lpLeft.snp.makeConstraints {
            $0.leading.equalTo(lastLPLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(lastLPLabel)
        }
        
        totalLPLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(lastLPLabel)
        }
        
        lpLabel.snp.makeConstraints {
            $0.trailing.equalTo(totalLPLabel.snp.leading).inset(-4)
            $0.centerY.equalTo(lastLPLabel)
        }
    }
    
    func addTierDetailButton() {
        containerView.addSubview(tierDetailButton)
        tierDetailButton.snp.makeConstraints {
            $0.top.equalTo(lpLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func configure(profile: MyProfileListResponse) {
        let max = profile.activeProfile.maxLp + 1
        let min = profile.activeProfile.minLp
        let current = profile.activeProfile.lp
        lastLPLabel.text = String(max - current)
        totalLPLabel.text = String(max)
        progressBar.progress = Float(current - min) / Float(max - min)
        tierBadge.image = Tier.from(tierCode: profile.activeProfile.tierCode)?.image
        tierImage.image = Tier.from(tierCode: profile.activeProfile.tierCode)?.badge

        // 추가: 활성화된 종목을 리스트의 가장 앞으로 보내거나
        // 서버에서 받은 전체 프로필 리스트를 reloadSports에 전달
        // self.reloadSports(with: profile.profiles.map { $0.sportCode })
    }

    func configure(profile: OtherUserProfileResponse) {
        let max = profile.selectedProfile.maxLp + 1
        let min = profile.selectedProfile.minLp
        let current = profile.selectedProfile.lp
        lastLPLabel.text = String(max - current)
        totalLPLabel.text = String(max)
        progressBar.progress = Float(current - min) / Float(max - min)
        tierBadge.image = Tier.from(tierCode: profile.selectedProfile.tierCode)?.image
        tierImage.image = Tier.from(tierCode: profile.selectedProfile.tierCode)?.badge

        let sortedSports = profile.allProfiles
            .sorted { (lhs, rhs) in
                (lhs.isCurrentlySelected ? 0 : 1) < (rhs.isCurrentlySelected ? 0 : 1)
            }
            .map(\.sportCode)
        reloadSports(with: sortedSports)
    }
    
    private func updatePlusButtonVisibility() {
        let allSports = Sports.allCases
        let isAllSelected = allSports.allSatisfy { selectedSports.contains($0) }
        
        plusButton.isHidden = isAllSelected
        
        sportsCollectionView.snp.updateConstraints {
            $0.trailing.equalTo(plusButton.snp.leading).offset(isAllSelected ? 48 : -8)
        }
    }
    
    func reloadSports(with sports: [Sports]) {
        self.selectedSports = sports
        self.sportsCollectionView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func detailTapped() {
        tierDetailAction?()
    }
    
    @objc private func plusTapped() {
        addAction?()
    }
}

extension TierCard: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let allSportsCount = Sports.allCases.count
        let currentCount = selectedSports.count
        
        return currentCount < allSportsCount ? currentCount + 1 : currentCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SportsButtonCell.reuseIdentifier, for: indexPath) as? SportsButtonCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.item < selectedSports.count {
            let sport = selectedSports[indexPath.item]
            cell.configure(with: sport, isSelected: indexPath.item == 0)
        } else {
            cell.configure(with: nil, isSelected: false)
        }
        
        cell.sportsAction = { [weak self] sports in
            self?.onSportsAction?(sports)
        }
        
        return cell
    }
}
