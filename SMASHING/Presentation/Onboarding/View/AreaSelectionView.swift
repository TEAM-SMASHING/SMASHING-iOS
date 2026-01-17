//
//  AreaSelectionView.swift
//  SMASHING
//
//  Created by 이승준 on 1/11/26.
//

import UIKit

import SnapKit
import Then

final class AreaSelectionView: BaseUIView {
    
    // MARK: - Properties
    
    private let placeholderText = "주소를 검색해주세요"
    
    var action: (() -> Void)?
    
    // MARK: - UI Components
    
    private lazy var addressButton = UIButton().then {
        $0.backgroundColor = .Background.canvas
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.Text.disabled.cgColor
        $0.addTarget(self, action: #selector(didTapAddressButton), for: .touchUpInside)
    }
    
    private let addressLabel = UILabel().then {
        $0.text = "주소를 검색해주세요"
        $0.textColor = .Text.disabled
        $0.font = .systemFont(ofSize: 16)
        $0.isUserInteractionEnabled = false
    }

    // MARK: - Setup Methods
    
    override func setUI() {
        addSubviews(addressButton)
        addressButton.addSubview(addressLabel)
    }
    
    override func setLayout() {
        addressButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(54)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapAddressButton() {
        action?()
    }
    
    // MARK: - Public Methods
    
    func updateAddress(address: String?) {
        if let address = address, !address.isEmpty {
            addressLabel.text = address
            addressLabel.textColor = .white
        } else {
            addressLabel.text = placeholderText
            addressLabel.textColor = .systemGray2
        }
    }
}
