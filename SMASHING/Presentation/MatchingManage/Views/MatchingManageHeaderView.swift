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

    private let tabContainerView = UIView().then {
        $0.backgroundColor = UIColor(resource: .Background.surface)
        $0.layer.cornerRadius = 16
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
        updateSelectedTab(.received)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Methods
    
    override func setUI() {
        super.setUI()
        self.backgroundColor = UIColor(resource: .Background.canvas)
        addSubview(tabContainerView)
        tabContainerView.addSubviews(receivedButton, sentRequestButton, requestConfirmedButton)
    }
    
    override func setLayout() {
        super.setLayout()

        tabContainerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        receivedButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(4)
            $0.top.bottom.equalToSuperview().inset(4)
        }

        sentRequestButton.snp.makeConstraints {
            $0.leading.equalTo(receivedButton.snp.trailing).offset(4)
            $0.top.bottom.equalToSuperview().inset(4)
            $0.width.equalTo(receivedButton)
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
        button.setTitleColor(UIColor(resource: .Text.primaryReverse), for: .selected)
        button.setTitleColor(UIColor(resource: .Text.disabled), for: .normal)
        button.titleLabel?.font = .pretendard(.textSmSb)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 12
        button.tag = tab.rawValue
        button.addTarget(self, action: #selector(tabButtonDidTap), for: .touchUpInside)
        return button
    }
    
    //MARK: - Actions
    
    @objc private func tabButtonDidTap(_ sender: UIButton) {
        guard let tab = Tab(rawValue: sender.tag) else { return }
        self.updateSelectedTab(tab)
        self.onTabSelected?(tab)
    }
    
    //MARK: Public Methods
    
    func updateSelectedTab(_ tab: Tab) {
        self.selectedTab = tab

        UIView.animate(withDuration: 0.3) {
            self.tabButtons.forEach { button in
                let isSelected = button.tag == tab.rawValue
                button.isSelected = isSelected
                button.backgroundColor = isSelected ? UIColor(resource: .Background.selected) : UIColor(resource: .Background.surface)
            }
        }
    }
    
}
