//
//  OnboardView.swift
//  SMASHING
//
//  Created by 이승준 on 1/11/26.
//

import UIKit

import SnapKit
import Then

final class OnboardingView: BaseUIView {
    
    // MARK: - UI Components
    
    let navigationBar = CustomNavigationBar(title: "", leftAction: nil)
    
    private let progressBar = UIProgressView().then {
        $0.tintColor = .State.progressFill
        $0.backgroundColor = .State.progressTrack
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }
    
    private let mainTitleLabel = UILabel().then {
        $0.font = .pretendard(.titleXlSb)
        $0.textColor = .Text.primary
        $0.numberOfLines = 0
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = .pretendard(.textMdM)
        $0.textColor = .Text.tertiary
        $0.numberOfLines = 0
    }
    
    let contentView = UIView().then {
        $0.backgroundColor = .Background.canvas
    }
    
    let nextButton = CTAButton(label: "다음")
    
    // MARK: - Setup Methods
    
    override func setUI() {
        backgroundColor = .Background.canvas
        addSubviews(
            navigationBar, progressBar,
            mainTitleLabel, subTitleLabel,
            contentView, nextButton
        )
    }
    
    override func setLayout() {
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
        
        contentView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(28)
            $0.bottom.equalTo(nextButton.snp.top)
        }
    }
    
    // MARK: - Public Methods
    
    /// 단계별 UI 상태를 업데이트합니다.
    func updateStepUI(title: String, subTitle: String, progress: Float, isLastStep: Bool) {
        mainTitleLabel.text = title
        subTitleLabel.text = subTitle
        progressBar.setProgress(progress, animated: true)
        
        let buttonTitle = isLastStep ? "완료" : "다음"
        nextButton.setTitle(buttonTitle, for: .normal)
    }
}
