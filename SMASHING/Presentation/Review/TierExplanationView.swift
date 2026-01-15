//
//  TierExplanationView.swift
//  SMASHING
//
//  Created by 이승준 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class TierExplanationView: BaseUIView {
    
    //MARK: - Properties
    
    private var dismissAction: (() -> Void)?
    
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
        $0.textColor = .Text.blue
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

class PaddingLabel: UILabel {
    var edgeInset: UIEdgeInsets = .zero
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: edgeInset.top, left: edgeInset.left, bottom: edgeInset.bottom, right: edgeInset.right)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + edgeInset.left + edgeInset.right,
                      height: size.height + edgeInset.top + edgeInset.bottom)
    }
}

final class TierChipCell : BaseUICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - Properties
    
    static let horizontalPadding: CGFloat = 16
    
    // MARK: - UI Components
    
    private let label = UILabel().then {
        $0.font = .pretendard(.textSmR)
        $0.textColor = .Text.secondary
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = false
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        layer.borderColor = UIColor.Text.secondary.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 20
        clipsToBounds = true
        addSubview(label)
    }
    
    override func setLayout() {
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: Public Methods
    
    func selected() {
        backgroundColor = .Background.canvasReverse
        layer.borderColor = UIColor.Background.canvasReverse.cgColor
        label.textColor = .Text.primaryReverse
    }
    
    func deselected() {
        backgroundColor = .Background.canvas
        layer.borderColor = UIColor.Text.primary.cgColor
        label.textColor = .Text.primary
    }
    
    func configure(with tier: OreTier) {
        label.text = tier.rawValue
    }
}

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

final class SkillExplanationCell: BaseUICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - UI Components
    
    private let containerView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .Text.primary
        $0.font = .pretendard(.textMdSb)
        $0.numberOfLines = 1
    }
    
    private let subtitleLabel = UILabel().then {
        $0.textColor = .Text.secondary
        $0.font = .pretendard(.textSmR)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    // MARK: - Lifecycle
    
    override func setUI() {
        contentView.addSubview(containerView)
        containerView.addSubviews(titleLabel, subtitleLabel)
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(with skill: SkillExplanation) {
        titleLabel.text = skill.name
        subtitleLabel.text = skill.explanation
    }
}

import SwiftUI
@available(iOS 19.0, *)
#Preview {
    TierExplanationViewController()
}
