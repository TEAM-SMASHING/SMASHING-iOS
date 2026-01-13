//
//  ChangeAddressView.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class ChangeAddressView: BaseUIView {
    
    // MARK: - Properties
    
    private var closeAction : (() -> Void)?
    
    private var completionAction: (() -> Void)?
    
    private var pushAddressSearchViewAction: (() -> Void)?
    
    // MARK: - UI Components
    
    private lazy var navigationBar = CustomNavigationBar(title: "내 지역 변경").then {
        $0.setLeftButtonHidden(true)
        $0.setRightButton(image: .icCloseLg, action: closeAction ?? {})
    }
    
    private let mainTitleLabel = UILabel().then {
        $0.font = .pretendard(.titleXlSb)
        $0.text = "활동 지역을 변경해주세요"
        $0.textColor = .Text.primary
        $0.numberOfLines = 0
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = .pretendard(.textMdM)
        $0.text = "서울 소재 주소만 입력 가능해요"
        $0.textColor = .Text.tertiary
        $0.numberOfLines = 0
    }
    
    private lazy var addressButton = UIButton().then {
        $0.backgroundColor = .Background.canvas
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        $0.addTarget(self, action: #selector(didTapAddressButton), for: .touchUpInside)
    }
    
    private let addressLabel = UILabel().then {
        $0.text = "주소를 검색해주세요"
        $0.textColor = .Text.disabled
        $0.font = .systemFont(ofSize: 16)
        $0.isUserInteractionEnabled = false
    }
    
    let nextButton = CTAButton(label: "완료").then {
        $0.addTarget(ChangeAddressView.self, action: #selector(didTapCompletionButton), for: .touchUpInside)
    }
    
    // MARK: - Life Cycle
    
    override func setUI() {
        addSubviews(navigationBar, mainTitleLabel, subTitleLabel, addressButton, nextButton)
        addressButton.addSubview(addressLabel)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(navigationBar.snp.bottom).offset(16)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(4)
        }
        
        addressButton.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(28)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(54)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-10)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapAddressButton() {
        pushAddressSearchViewAction?()
    }
    
    @objc private func didTapCompletionButton() {
        completionAction?()
    }
    
    // MARK: - Public Methods
    
    func configure(closeAction : (() -> Void)? = nil,
                    completionAction: (() -> Void)? = nil,
                   pushAddressSearchViewAction: (() -> Void)? = nil) {
        self.closeAction = closeAction
        self.completionAction = completionAction
        self.pushAddressSearchViewAction = pushAddressSearchViewAction
    }
}

final class ChangeAddressViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let mainView = ChangeAddressView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        self.view = mainView
    }
}
