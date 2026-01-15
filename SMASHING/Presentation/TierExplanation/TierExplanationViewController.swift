//
//  TierExplanationView.swift
//  SMASHING
//
//  Created by 이승준 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class TierExplanationViewController: BaseViewController {
    
    private let mainView = TierExplanationView()
    private var sports: Sports = .tableTennis
    private var oreTier: OreTier = .bronze
    
    override func loadView() {
        view = mainView
        
        mainView.configure(oreTier: oreTier, sports: sports)
        mainView.tierCollectionView.delegate = self
        mainView.tierCollectionView.dataSource = self
        mainView.tierExplanationCollectionView.delegate = self
        mainView.tierExplanationCollectionView.dataSource = self
    }
}

// MARK: - Extensions : UICollectionViewDelegateFlowLayout

extension TierExplanationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainView.tierCollectionView {
            let tier = OreTier.allCases[indexPath.item]
            let label = UILabel().then {
                $0.font = UIFont.pretendard(.textSmR)
                $0.text = tier.rawValue
                $0.textColor = .white
                $0.sizeToFit()
            }
            let cellWidth = label.frame.width + TierChipCell.horizontalPadding * 2
            return CGSize(width: cellWidth, height: 40)
        } else {
            let width = collectionView.frame.width - 32
            return CGSize(width: width, height: 110)
        }
    }
}

// MARK: - Extensions : UICollectionViewDelegate, UICollectionViewDataSource

extension TierExplanationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainView.tierCollectionView {
            return OreTier.allCases.count
        } else {
            return OreTier.diamond.skills(sports: .tableTennis).count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainView.tierCollectionView {
            let cell = collectionView.dequeueReusableCell(TierChipCell.self, for: indexPath)
            if indexPath.row == oreTier.index {
                cell.selected()
            } else {
                cell.deselected()
            }
            cell.configure(with: OreTier.allCases[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(SkillExplanationCell.self, for: indexPath)
            cell.contentView.snp.makeConstraints {
                $0.width.equalTo(collectionView.frame.width)
            }
            cell.configure(with: oreTier.skills(sports: sports)[indexPath.row])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mainView.tierCollectionView && oreTier.index != indexPath.row {
            oreTier = OreTier.allCases[indexPath.row]
            collectionView.reloadData()
            mainView.tierExplanationCollectionView.reloadData()
            mainView.configure(oreTier: oreTier, sports: sports)
        }
    }
}


import SwiftUI
@available(iOS 19.0, *)
#Preview {
    TierExplanationViewController()
}
