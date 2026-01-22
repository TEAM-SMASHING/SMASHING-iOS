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
    
    private let myImage = UIImageView().then {
        $0.image = UIImage(systemName: "circle.fill")
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 32
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
    
    private let rivalImage = UIImageView().then {
        $0.image = UIImage(systemName: "circle.fill")
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 32
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
    }
    
    private let rivalNickName = UILabel().then {
        $0.text = "와구와구"
        $0.setPretendard(.textSmM)
        $0.textColor = .Text.muted
        $0.textAlignment = .center
    }
    
    lazy var writeResultButton = UIButton().then {
        $0.setTitle("결과 작성하기", for: .normal)
        $0.titleLabel?.font = .pretendard(.textMdM)
        $0.setTitleColor(.Text.muted, for: .normal)
        $0.backgroundColor = .Button.backgroundPrimaryActive
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(writeResultButtonDidTap), for: .touchUpInside)
    }
    
    override func setUI() {
        containerView.addSubviews(myImage, myNickName, rivalImage, rivalNickName, VSImage, writeResultButton)
        
        contentView.addSubviews(containerView)
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        myImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.leading.equalToSuperview().inset(44)
            $0.size.equalTo(64)
        }
        
        myNickName.snp.makeConstraints {
            $0.top.equalTo(myImage.snp.bottom).offset(4)
            $0.centerX.equalTo(myImage)
        }
        
        VSImage.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(24)
            $0.width.equalTo(100)
            $0.height.equalTo(108)
            $0.centerX.equalToSuperview()
        }
        
        rivalImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.trailing.equalToSuperview().inset(44)
            $0.size.equalTo(64)
        }
        
        rivalNickName.snp.makeConstraints {
            $0.top.equalTo(rivalImage.snp.bottom).offset(4)
            $0.centerX.equalTo(rivalImage)
        }
        
        writeResultButton.snp.makeConstraints {
            $0.top.equalTo(VSImage.snp.bottom).offset(20)
            $0.bottom.equalTo(containerView.snp.bottom).inset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        }
    }
    
    func configure(with matching: MatchingConfirmedGameDTO, myNickname: String, myUserId: String) {
        myImage.image = UIImage.defaultProfileImage(name: myNickname)
        rivalImage.image = UIImage.defaultProfileImage(name: matching.opponent.nickname)
        myNickName.text = myNickname
        rivalNickName.text = matching.opponent.nickname
        
        let resultStatus = matching.resultStatus
        let isMySubmission = matching.latestSubmitterId == myUserId
        
        // WAITING_CONFIRMATION 상태에서 상대방이 제출했으면 확인 가능
        let canConfirm = resultStatus.canConfirm(isMySubmission: isMySubmission)
        let canSubmit = resultStatus.canSubmit(isMySubmission: isMySubmission) && !matching.isSubmitLocked
        //        let canSubmit = resultStatus.canSubmit && !matching.isSubmitLocked
        
        let buttonTitle = resultStatus.buttonTitle(isMySubmission: isMySubmission)
        
        writeResultButton.setTitle(buttonTitle, for: .normal)
        writeResultButton.isEnabled = canSubmit || canConfirm
        
        updateButtonStyle(for: resultStatus, isMySubmission: isMySubmission ,canSubmit: canSubmit, canConfirm: canConfirm)
    }
    
    private func updateButtonStyle(for status: GameResultStatus, isMySubmission: Bool, canSubmit: Bool, canConfirm: Bool) {
        
        switch status {
        case .pendingResult:
            writeResultButton.backgroundColor = .Button.backgroundPrimaryActive
            writeResultButton.setTitleColor(.Text.emphasis, for: .normal)
        case .resultRejected:
            if canSubmit {
                writeResultButton.backgroundColor = .Button.backgroundRejected
                writeResultButton.setTitleColor(.Button.textRejected, for: .normal)
            } else {
                writeResultButton.backgroundColor = .Button.backgroundPrimaryDisabled
                writeResultButton.setTitleColor(.Button.textPrimaryDisabled, for: .normal)
            }
        case .waitingConfirmation:
            if canConfirm {
                // 상대방이 제출 → 내가 확인해야 함
                writeResultButton.backgroundColor = .Button.backgroundConfirmed
                writeResultButton.setTitleColor(.Button.backgroundSecondaryActive, for: .normal)
            } else {
                writeResultButton.backgroundColor = .Button.backgroundPrimaryDisabled
                writeResultButton.setTitleColor(.Button.textPrimaryDisabled, for: .normal)
            }
            
        case .canceled:
            writeResultButton.backgroundColor = .Button.backgroundPrimaryDisabled
            writeResultButton.setTitleColor(.Button.textPrimaryDisabled, for: .normal)
        case .resultConfirmed:
            break
        }
    }
    
    @objc
    private func writeResultButtonDidTap() {
        print("🔴 writeResultButtonDidTap 호출됨")
        onWriteResultButtonTapped?()
    }
}
