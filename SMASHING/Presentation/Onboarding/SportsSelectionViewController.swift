//
//  SportsSelectionViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/9/26.
//

import UIKit

import SnapKit
import Then

final class SportsChip: BaseUIView {
    
    // MARK: - Properties
    
    private let sport: Sports
    
    var isSelected: Bool = false {
        didSet { updateStyle() }
    }

    // MARK: - UI Components
    
    private let contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
        $0.isUserInteractionEnabled = false
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let label = UILabel().then {
        $0.font = .pretendard(.textMdM) // 프로젝트의 폰트 시스템 사용
    }

    // MARK: - Init
    
    init(sport: Sports) {
        self.sport = sport
        super.init(frame: .zero)
        setupAttributes()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAttributes() {
        self.layer.cornerRadius = 20 // 칩 형태를 위한 둥근 모서리
        self.layer.borderWidth = 1
        self.label.text = sport.rawValue
        updateStyle()
    }

    override func setUI() {
        addSubview(contentStackView)
        [imageView, label].forEach { contentStackView.addArrangedSubview($0) }
    }

    override func setLayout() {
        contentStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(24)
        }
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }

    private func updateStyle() {
        if isSelected {
            self.backgroundColor = .Background.selected
            self.layer.borderColor = UIColor.clear.cgColor
            self.imageView.image = sport.image.tinted(with: .Text.primaryReverse)
            self.label.textColor = .Text.primaryReverse
        } else {
            self.backgroundColor = .clear
            self.layer.borderColor = UIColor.Border.secondary.cgColor
            self.imageView.image = sport.image
            self.label.textColor = .Text.primary
        }
    }
}

final class SportsSelectionViewController: BaseViewController {
    
    // MARK: - Properties
        
    private let sportsView = SportsSelectionView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = sportsView
        view.backgroundColor = .clear
    }
    
    // MARK: - Setup Methods
    
    func configure(action: @escaping (Sports) -> Void) {
        sportsView.configure(action: action)
    }
}

final class SportsSelectionView: BaseUIView {
    
    // MARK: - Properties
    
    private var action: ((Sports) -> Void)?
    private var chips: [SportsChip] = []

    // MARK: - UI Components
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 10
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        addSubview(stackView)
        
        [Sports.badminton, .tableTennis, .tennis].forEach { sport in
            let chip = SportsChip(sport: sport)
            chip.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chipTapped(_:))))
            chips.append(chip)
            stackView.addArrangedSubview(chip)
        }
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.height.equalTo(40)
        }
    }
    
    func configure(action: @escaping (Sports) -> Void) {
        self.action = action
    }
    
    // MARK: - Actions
    
    @objc private func chipTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedChip = sender.view as? SportsChip else { return }
        
        // Single Selection 로직
        chips.forEach { $0.isSelected = ($0 === selectedChip) }
        
        // 선택된 데이터 전달 (Enum 케이스 찾기)
        if let sport = getSport(from: selectedChip) {
            action?(sport)
        }
    }
    
    // MARK: - Private Methods
    
    private func getSport(from chip: SportsChip) -> Sports? {
        // 칩 내부의 sport 프로퍼티를 가져오거나,
        // 칩 생성 시 sport 값을 저장해두는 방식으로 구현
        // (위의 SportsChip 코드에 저장된 sport 활용)
        return Mirror(reflecting: chip).children.first(where: { $0.label == "sport" })?.value as? Sports
    }
}
