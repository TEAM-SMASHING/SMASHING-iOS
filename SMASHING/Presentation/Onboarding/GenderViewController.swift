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
    private var selectedGender: Gender? {
        didSet {
            updateUIBySelection()
        }
    }

    // MARK: - UI Components
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 11
    }
    
    private let maleButton = UIView().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.Border.secondary.cgColor // 기본 테두리
        $0.backgroundColor = .clear
    }
    
    private let femaleButton = UIView().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.Border.secondary.cgColor
        $0.backgroundColor = .clear
    }
    
    private let maleImageView = UIImageView().then {
        $0.image = Gender.male.imageLg
        $0.tintColor = .Button.textPrimaryActive
        $0.contentMode = .scaleAspectFit
    }
    
    private let maleLabel = UILabel().then {
        $0.text = Gender.male.name
        $0.font = .pretendard(.textMdM)
        $0.textColor = .systemGray
    }
    
    private let femaleImageView = UIImageView().then {
        $0.image = Gender.female.imageLg
        $0.contentMode = .scaleAspectFit
    }
    
    private let femaleLabel = UILabel().then {
        $0.text = Gender.female.name
        $0.font = .pretendard(.textMdM)
        $0.textColor = .systemGray
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        self.addSubview(stackView)
        
        [maleButton, femaleButton].forEach { stackView.addArrangedSubview($0) }
        
        // 버튼 내부에 이미지와 레이블 배치 (수직 중앙 정렬)
        let maleContentStack = UIStackView(arrangedSubviews: [maleImageView, maleLabel]).then {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 8
            $0.isUserInteractionEnabled = false
        }
        
        let femaleContentStack = UIStackView(arrangedSubviews: [femaleImageView, femaleLabel]).then {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 8
            $0.isUserInteractionEnabled = false
        }
        
        maleButton.addSubview(maleContentStack)
        femaleButton.addSubview(femaleContentStack)
        
        maleContentStack.snp.makeConstraints { $0.center.equalToSuperview() }
        femaleContentStack.snp.makeConstraints { $0.center.equalToSuperview() }
        
        // 아이콘 크기 고정 (24x24)
        maleImageView.snp.makeConstraints { $0.size.equalTo(24) }
        femaleImageView.snp.makeConstraints { $0.size.equalTo(24) }
        
        // 탭 제스처 추가
        maleButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maleTapped)))
        femaleButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(femaleTapped)))
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            // 높이는 너비가 결정된 후 계산하여 업데이트하기 위해 임시 설정하거나 아래 layoutSubviews 활용
            $0.height.equalTo(0)
        }
    }
    
    // View의 너비를 계산할 수 있는 시점에 높이 제약 조건을 추가/업데이트
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.frame.width
        if width > 0 {
            stackView.snp.updateConstraints {
                $0.height.equalTo(width / 2 - 11)
            }
        }
    }
    
    func configure(action: ((Gender) -> Void)? = nil) {
        self.action = action
    }
    
    // MARK: - Private Methods
    
    private func updateUIBySelection() {
        // 남성 버튼 UI 업데이트
        let isMaleSelected = selectedGender == .male
        maleButton.layer.borderColor = isMaleSelected ? nil : UIColor.systemGray4.cgColor
        maleButton.backgroundColor = isMaleSelected ? .Background.selected : .clear
        maleImageView.image = isMaleSelected ? .icManLg
            .tinted(with: .Text.primaryReverse) : .icManLg
        maleLabel.textColor = isMaleSelected ? .Text.primaryReverse : .Text.primary
        
        // 여성 버튼 UI 업데이트
        let isFemaleSelected = selectedGender == .female
        femaleButton.layer.borderColor = isFemaleSelected ? nil : UIColor.systemGray4.cgColor
        femaleButton.backgroundColor = isFemaleSelected ? .Background.selected : .clear
        femaleImageView.image = isFemaleSelected ? .icWomanLg
            .tinted(with: .Text.primaryReverse) : .icWomanLg
        femaleLabel.textColor = isFemaleSelected ? .Text.primaryReverse : .Text.primary
    }
    
    // MARK: - Actions
    
    @objc private func maleTapped() {
        selectedGender = .male
        action?(.male)
    }
    
    @objc private func femaleTapped() {
        selectedGender = .female
        action?(.female)
    }
}
