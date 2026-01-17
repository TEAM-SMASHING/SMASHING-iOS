//
//  AddressSearchView.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class AddressSearchView: BaseUIView {
    
    // MARK: - Properties
    
    var backAction: ((String) -> Void)?
    
    // MARK: - UI Components
    
    private lazy var backButtton = UIButton().then {
        $0.setImage(.icArrowLeft, for: .normal)
        $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    let searchTextField = SearchTextField()
    
    let resultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
    }).then {
        $0.backgroundColor = .clear
        $0.register(AddressSearchResultCell.self,
                    forCellWithReuseIdentifier: AddressSearchResultCell.reuseIdentifier)
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        addSubviews(backButtton, searchTextField, resultCollectionView)
    }
    
    override func setLayout() {
        backButtton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.size.equalTo(24)
        }
        
        searchTextField.snp.makeConstraints {
            $0.centerY.equalTo(backButtton)
            $0.leading.equalTo(backButtton.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        resultCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        backAction?(searchTextField.text ?? "")
    }
}
