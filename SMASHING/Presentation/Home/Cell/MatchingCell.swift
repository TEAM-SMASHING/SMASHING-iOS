//
//  MatchingCell.swift
//  SMASHING
//
//  Created by 홍준범 on 1/11/26.
//

import UIKit

import Then
import SnapKit

final class MatchingCell: BaseUICollectionViewCell, ReuseIdentifiable {
    
    var onWriteResultButtonTapped: (() -> Void)?
    
    private let containerView = UIView().then {
        $0.backgroundColor = .Background.surface
        $0.layer.cornerRadius = 8
        $0.isUserInteractionEnabled = true
    }
    
    private let leftProfileStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
    }
    
    private let myImage = UIImageView().then {
        $0.image = UIImage(systemName: "circle.fill")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
    }
    
    private let myNickName = UILabel().then {
        $0.text = "밤이달이"
        $0.setPretendard(.textSmM)
        $0.textColor = .Text.muted
        $0.textAlignment = .center
    }
    
    private let VSImage = UIImageView().then {
        $0.image = .icVs
        $0.contentMode = .scaleAspectFit
    }
    
    private let rightProfileStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
    }
    
    private let rivalImage = UIImageView().then {
        $0.image = UIImage(systemName: "circle.fill")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
    }
    
    private let rivalNickName = UILabel().then {
        $0.text = "와구와구"
        $0.setPretendard(.textSmM)
        $0.textColor = .Text.muted
        $0.textAlignment = .center
    }
    
    private let writeResultButton = UIButton().then {
        $0.setTitle("결과 작성하기", for: .normal)
        $0.titleLabel?.font = .pretendard(.textMdM)
        $0.setTitleColor(.Text.muted, for: .normal)
        $0.backgroundColor = .Button.backgroundPrimaryActive
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(writeResultButtonDidTap), for: .touchUpInside)
    }
    
    override func setUI() {
        leftProfileStackView.addArrangedSubviews(myImage, myNickName)
        
        rightProfileStackView.addArrangedSubviews(rivalImage, rivalNickName)
        
        containerView.addSubviews(leftProfileStackView, rightProfileStackView, VSImage, writeResultButton)
        
        contentView.addSubviews(containerView)
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        myImage.snp.makeConstraints {
            $0.size.equalTo(64)
        }
        
        leftProfileStackView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(25.5)
            $0.leading.equalTo(containerView.snp.leading).inset(50.5)
        }
        
        VSImage.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        rivalImage.snp.makeConstraints {
            $0.size.equalTo(64)
        }
        
        rightProfileStackView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).inset(25.5)
            $0.trailing.equalTo(containerView.snp.trailing).inset(50.5)
        }
        
        writeResultButton.snp.makeConstraints {
            $0.bottom.equalTo(containerView.snp.bottom).inset(18)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        }
    }
    
    func configure(with matching: MatchingConfirmedGameDTO, myNickname: String) {
        myNickName.text = myNickname
        rivalNickName.text = matching.opponent.nickname
        
        let resultStatus = matching.resultStatus
        // 버튼 활성화 여부
        let canSubmit = resultStatus.canSubmit && !matching.isSubmitLocked
        
        writeResultButton.setTitle(resultStatus.buttonTitle, for: .normal)
        writeResultButton.isEnabled = canSubmit
        
        updateButtonStyle(for: resultStatus, canSubmit: canSubmit)
    }
    
    private func updateButtonStyle(for status: GameResultStatus, canSubmit: Bool) {
        
        switch status {
        case .pendingResult:
            writeResultButton.backgroundColor = .Button.backgroundPrimaryActive
            writeResultButton.setTitleColor(.Text.emphasis, for: .normal)
        case .resultRejected:
            writeResultButton.backgroundColor = .Button.backgroundPrimaryDisabled
            writeResultButton.setTitleColor(.Button.textRejected, for: .normal)
        case .waitingConfirmation:
            writeResultButton.backgroundColor = .Button.backgroundPrimaryDisabled
            writeResultButton.setTitleColor(.Button.textPrimaryDisabled, for: .normal)
        case .canceled:
            writeResultButton.backgroundColor = .Button.backgroundPrimaryDisabled
            writeResultButton.setTitleColor(.Button.textPrimaryDisabled, for: .normal)
        case .resultConfirmed:
            writeResultButton.backgroundColor = .Button.backgroundConfirmed
            writeResultButton.setTitleColor(.Text.emphasis, for: .normal)
        }
    }
    
    @objc
    private func writeResultButtonDidTap() {
        print("🔴 writeResultButtonDidTap 호출됨")
        onWriteResultButtonTapped?()
    }
}
