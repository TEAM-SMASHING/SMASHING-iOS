//
//  ToastMessage.swift
//  Coordinator-Pattern
//
//  Created by 이승준 on 1/10/26.
//

import UIKit

import SnapKit
import Then

final class ToastMessage: BaseUIView {
    
    // MARK: - Properties
    
    private var action: (() -> Void)?
    
    // MARK: - UI Components
    
    private lazy var messageLabel = UILabel().then {
        $0.text = "Toast Message"
        $0.textColor = .Text.primaryReverse
        $0.font = .pretendard(.captionXsM)
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        backgroundColor = .Background.canvasReverse
        layer.cornerRadius = 8
        clipsToBounds = true
        
        addSubview(messageLabel)
    }
    
    override func setLayout() {
        messageLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
    }
    
    override func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
    
    func show() {
        self.snp.makeConstraints {
            $0.height.equalTo(49)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(100)
        }
        dissmissToastMessage()
    }
    
    func configure(title: String) {
        self.messageLabel.text = title
    }
    
    func configure(title: String , action: (() -> Void)? = nil) {
        self.messageLabel.text = title
        self.action = action
    }
    
    // MARK: - Actions
    
    @objc private func handleTap() {
        action?()
    }
    
    // MARK: - Private Methods
    
    private func dissmissToastMessage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { _ in
                self.removeFromSuperview()
            }
        }
    }
}
