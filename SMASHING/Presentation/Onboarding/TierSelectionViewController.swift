//
//  TierSelectionViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/9/26.
//

import UIKit

import SnapKit
import Then

final class TierButton: BaseUIView {
    
    // MARK: - Properties
    
    private let tier: Tier
    private let title: String
    
    var isSelected: Bool = false {
        didSet { updateStyle() }
    }

    // MARK: - UI Components
    
    private let contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 12
        $0.isUserInteractionEnabled = false
    }
    
    private let radioButtonImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let label = UILabel().then {
        $0.font = .pretendard(.textMdM)
        $0.textColor = .Text.primary
    }

    // MARK: - Init
    
    init(tier: Tier, title: String) {
        self.tier = tier
        self.title = title
        super.init(frame: .zero)
        backgroundColor = .clear
        setupAttributes()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAttributes() {
        self.label.text = title
        updateStyle()
    }

    override func setUI() {
        addSubview(contentStackView)
        [radioButtonImageView, label].forEach { contentStackView.addArrangedSubview($0) }
    }

    override func setLayout() {
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
        
        radioButtonImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
    
    // MARK: - Private Methods

    private func updateStyle() {
        if isSelected {
            radioButtonImageView.image = .icRadioFill
        } else {
            radioButtonImageView.image = .icRadioEmpty
        }
    }
    
    // MARK: - Public Methods
    
    func getTier() -> Tier {
        return self.tier
    }
}

final class TierSelectionView: BaseUIView {
    
    // MARK: - Properties
    
    private var action: ((Tier) -> Void)?
    private var buttons: [TierButton] = []
    
    private let tierOptions: [(Tier, String)] = [
        (.iron, "3개월 미만"),
        (.bronze3, "3개월 이상 ~ 6개월 미만"),
        (.bronze2, "6개월 이상 ~ 1년 미만"),
        (.bronze1, "1년 이상 ~ 1년 반 미만"),
        (.silver3, "1년 반 이상")
    ]

    // MARK: - UI Components
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        addSubview(stackView)
        
        tierOptions.forEach { option in
            let button = TierButton(tier: option.0, title: option.1)
            button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:))))
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.height.equalTo(232)
        }
    }
    
    func configure(action: @escaping (Tier) -> Void) {
        self.action = action
    }
    
    // MARK: - Actions
    
    @objc private func buttonTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedButton = sender.view as? TierButton else { return }
        
        buttons.forEach { $0.isSelected = ($0 === selectedButton) }
        
        action?(selectedButton.getTier())
    }
}

final class TierSelectionViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let selectionView = TierSelectionView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = selectionView
        view.backgroundColor = .clear
    }
    
    // MARK: - Setup Methods
    
    func configure(action: @escaping (Tier) -> Void) {
        selectionView.configure(action: action)
    }
}
