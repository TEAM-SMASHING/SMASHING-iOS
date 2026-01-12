//
//  NavigationBar.swift
//  SMASHING
//
//  Created by 이승준 on 1/7/26.
//

import UIKit

import SnapKit
import Then

final class CustomNavigationBar: BaseUIView {
    
    // MARK: - Properties
    
    private var leftAction: (() -> Void)?
    private var rightAction: (() -> Void)?
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.primary
        $0.textAlignment = .center
    }
    
    private lazy var leftBackButton = UIButton().then {
        $0.setImage(.icArrowLeft, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.contentHorizontalAlignment = .fill
        $0.contentVerticalAlignment = .fill
        $0.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        $0.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
    }
    
    private lazy var rightButton = UIButton().then {
        $0.isHidden = true
        $0.imageView?.contentMode = .scaleAspectFit
        $0.contentHorizontalAlignment = .fill
        $0.contentVerticalAlignment = .fill
        $0.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        $0.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Init
    
    init(title: String, leftAction: (() -> Void)? = nil) {
        super.init(frame: .zero)
        self.leftAction = leftAction
        self.titleLabel.text = title
        
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setAttributes() {
        self.backgroundColor = .Background.canvas
    }
    
    override func setUI() {
        addSubviews(leftBackButton, titleLabel, rightButton)
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(66)
        }
        
        leftBackButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(6)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-6)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(44)
        }
    }
    
    // MARK: - Public Methods
    
    func setLeftButtonHidden(_ isHidden: Bool) {
        leftBackButton.isHidden = isHidden
    }
    
    func setRightButton(image: UIImage?, action: @escaping () -> Void) {
        rightButton.setImage(image, for: .normal)
        rightButton.isHidden = false
        self.rightAction = action
    }
    
    func setLeftButton(action: @escaping () -> Void) {
        self.leftAction = action
    }
    
    // MARK: - Actions
    
    @objc private func leftButtonTapped() {
        leftAction?()
    }
    
    @objc private func rightButtonTapped() {
        rightAction?()
    }
}
