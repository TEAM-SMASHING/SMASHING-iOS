//
//  AddressSearchController.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

import UIKit

final class AddressSearchViewController: BaseViewController {
    
    private let mainView = AddressSearchView()
    
    private let dummyAddresses = [
        "서울특별시",
        "서울특별시 성북구",
        "서울특별시 성북구 안암로",
        "서울특별시 성북구 안암로 1길"
    ]
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
    }
    
    private func setDelegate() {
        mainView.resultCollectionView.dataSource = self
        mainView.resultCollectionView.delegate = self
    }
}

extension AddressSearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyAddresses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddressSearchResultCell.reuseIdentifier, for: indexPath) as? AddressSearchResultCell else {
            return UICollectionViewCell()
        }
        cell.configure(address: dummyAddresses[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 55)
    }
}
