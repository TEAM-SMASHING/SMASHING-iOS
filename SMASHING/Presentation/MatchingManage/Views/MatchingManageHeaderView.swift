//
//  MatchingManageHeaderView.swift
//  SMASHING
//
//  Created by JIN on 1/12/26.
//

import UIKit

import SnapKit
import Then

class MatchingManageHeaderView: BaseUIView {
    
    // MARK: - Types
    
    enum Tab: Int, CaseIterable {
        case received = 0
        case sent = 1
        case confirmed = 2
        
        var title: String {
            switch self {
            case .received: return "받은 요청"
            case .sent: return "보낸 요청"
            case .confirmed: return "매칭 확정"
            }
        }
    }
    
    //MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.text = "매칭 관리"
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private let tabContainerView = UIView().then {
        $0.backgroundColor = UIColor(resource: .Background.canvas)
        $0.layer.cornerRadius = 12
    }
    
    private lazy var receivedButton = createTabButton(for: .received)
    private lazy var requestConfirmedButton = createTabButton(for: .confirmed)
    private lazy var sentRequestButton = createTabButton(for: .sent)
    private lazy var tabButtons: [UIButton] = [receivedButton, sentRequestButton, requestConfirmedButton]
    
    //MARK: - Properties
    
    var onTabSelected: ((Tab) -> Void)?
    private var selectedTab: Tab = .received
    
    //MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Methods
    
    override func setUI() {
        super.setUI()
        self.backgroundColor = UIColor(resource: .Background.canvas)
        addSubviews(titleLabel, tabContainerView)
        tabContainerView.addSubviews(receivedButton, sentRequestButton, requestConfirmedButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.width.equalTo(59)
            $0.height.equalTo(24)
        }
        
        tabContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(113)
            $0.bottom.equalToSuperview().offset(-11)
            $0.width.equalTo(343)
            $0.height.equalTo(48)
        }
        
        receivedButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(4)
            $0.top.bottom.equalToSuperview().inset(4)
            $0.width.equalTo(sentRequestButton)
        }
        
        sentRequestButton.snp.makeConstraints {
            $0.leading.equalTo(receivedButton.snp.trailing).offset(4)
            $0.top.bottom.equalToSuperview().inset(4)
            $0.width.equalTo(requestConfirmedButton)
        }
        
        requestConfirmedButton.snp.makeConstraints {
            $0.leading.equalTo(sentRequestButton.snp.trailing).offset(4)
            $0.trailing.equalToSuperview().offset(-4)
            $0.top.bottom.equalToSuperview().inset(4)
            $0.width.equalTo(receivedButton)
        }
    }
    
    //MARK: - Private Method
    
    private func createTabButton(for tab: Tab) -> UIButton {
        let button = UIButton()
        button.setTitle(tab.title, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.setTitleColor(UIColor(white: 0.5, alpha: 1.0), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.tag = tab.rawValue
        button.addTarget(self, action: #selector(tabButtonDidTap), for: .touchUpInside)
        return button
    }
    
    //MARK: - Actions
    
    @objc private func tabButtonDidTap(_ sender: UIButton) {
        guard let tab = Tab(rawValue: sender.tag) else { return }
        self.updateSelectedTab(tab)
    }
    
    //MARK: Public Methods
    
    func updateSelectedTab(_ tab: Tab) {
        self.selectedTab = tab
        
        UIView.animate(withDuration: 0.3) {
            self.tabButtons.forEach { button in
                let isSelected = button.tag == tab.rawValue
                button.backgroundColor = isSelected ? UIColor(resource: .Button.textPrimaryActive) : UIColor(resource: .Button.backgroundPrimaryActive)
            }
        }
    }
    
}
