//
//  TierExplanationViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/21/26.
//

import UIKit

import SnapKit
import Then

final class TierExplanationViewController: BaseViewController {

    var dismissAction: (() -> Void)?
    private var sports: Sports
    private var oreTier: OreTier
    private let mainView = TierExplanationView()
        
    override func loadView() {
        view = mainView
        mainView.tierCollectionView.delegate = self
        mainView.tierCollectionView.dataSource = self
        mainView.tierExplanationCollectionView.delegate = self
        mainView.tierExplanationCollectionView.dataSource = self
        
        setupDismissAction()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(sports: Sports, oreTier: OreTier) {
        self.sports = sports
        self.oreTier = oreTier
        super.init(nibName: nil, bundle: nil)
        mainView.configure(oreTier: oreTier, sports: sports)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupDismissAction() {
        if let action = dismissAction {
            mainView.dismissAction = action
        }
    }
}

// MARK: - Extensions

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

extension TierExplanationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainView.tierCollectionView {
            return OreTier.allCases.count
        } else {
            return oreTier.skills(sports: sports).count
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
