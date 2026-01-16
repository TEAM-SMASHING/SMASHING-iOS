//
//  OnboardingContainerView.swift
//  SMASHING
//
//  Created by 이승준 on 1/8/26.
//

import UIKit

import SnapKit
import Then

final class OnboardingContainerView: UIView {
    
    // MARK: - Actions
    
    var backAction: (() -> Void)?
    var nextAction: (() -> Void)?
    
    // MARK: - UI Components
    
    lazy var navigationBar = CustomNavigationBar(title: "", leftAction: self.backAction ?? {})
    
    let progressBar = UIProgressView().then {
        $0.tintColor = .State.progressFill
        $0.backgroundColor = .State.progressTrack
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }
    
    let mainTitleLabel = UILabel().then {
        $0.font = .pretendard(.titleXlSb)
        $0.textColor = .Text.primary
    }
    
    let subTitleLabel = UILabel().then {
        $0.font = .pretendard(.textMdM)
        $0.textColor = .Text.tertiary
    }
    
    let containerView = UIView().then {
        $0.backgroundColor = .Background.canvas
    }
    
    lazy var nextButton = CTAButton(label: "다음").then {
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        addSubviews(
            navigationBar, progressBar,
            mainTitleLabel, subTitleLabel,
            containerView, nextButton
        )
    }
    
    private func setupLayout() {
        navigationBar.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(safeAreaLayoutGuide)
        }
        
        progressBar.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.height.equalTo(8)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(progressBar.snp.bottom).offset(16)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(4)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        containerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(28)
            $0.bottom.equalTo(nextButton.snp.top)
        }
    }
    
    // MARK: - Actions
    
    @objc private func nextButtonTapped() {
        nextAction?()
    }    
}
