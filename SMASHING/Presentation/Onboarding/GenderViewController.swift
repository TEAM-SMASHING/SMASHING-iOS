//
//  GenderViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/9/26.
//

import UIKit

import SnapKit
import Then

final class GenderViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let genderView = GenderView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        view = genderView
        view.backgroundColor = .clear
    }
}

final class GenderView: BaseUIView {
    
    // MARK: - Properties
    
    private var action: ((Gender) -> Void)?
    
    // MARK: - UI Components
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 11
    }
    
    private let maleButton = GenderButton(gender: .male)
    private let femaleButton = GenderButton(gender: .female)

    // MARK: - Setup
    
    override func setUI() {
        addSubview(stackView)
        [maleButton, femaleButton].forEach { stackView.addArrangedSubview($0) }
        
        // 탭 액션 연결
        maleButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maleTapped)))
        femaleButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(femaleTapped)))
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            // 고정 비율(Aspect Ratio) 사용으로 layoutSubviews 제거 가능
            $0.height.equalTo(stackView.snp.width).multipliedBy(0.5).offset(-11)
        }
    }
    
    func configure(action: ((Gender) -> Void)? = nil) {
        self.action = action
    }
    
    // MARK: - Actions
    @objc private func maleTapped() {
        updateSelection(selected: .male)
        action?(.male)
    }
    
    @objc private func femaleTapped() {
        updateSelection(selected: .female)
        action?(.female)
    }
    
    private func updateSelection(selected: Gender) {
        maleButton.isSelected = (selected == .male)
        femaleButton.isSelected = (selected == .female)
    }
}

final class GenderButton: BaseUIView {
    
    // MARK: - Properties
    private let gender: Gender
    
    var isSelected: Bool = false {
        didSet {
            updateStyle()
        }
    }

    // MARK: - UI Components
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 8
        $0.isUserInteractionEnabled = false
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let label = UILabel().then {
        $0.font = .pretendard(.textMdM)
    }

    // MARK: - Init
    init(gender: Gender) {
        self.gender = gender
        super.init(frame: .zero)
        setupData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    private func setupData() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.label.text = gender.name
        updateStyle()
    }

    override func setUI() {
        addSubview(contentStackView)
        [imageView, label].forEach { contentStackView.addArrangedSubview($0) }
    }

    override func setLayout() {
        contentStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        imageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }

    private func updateStyle() {
        if isSelected {
            self.backgroundColor = .Background.selected
            self.layer.borderColor = UIColor.clear.cgColor
            self.imageView.image = gender.imageLg.tinted(with: .Text.primaryReverse)
            self.label.textColor = .Text.primaryReverse
        } else {
            self.backgroundColor = .clear
            self.layer.borderColor = UIColor.systemGray4.cgColor
            self.imageView.image = gender.imageLg
            self.label.textColor = .Text.primary
        }
    }
}
