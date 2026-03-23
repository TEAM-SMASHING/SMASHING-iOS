//
//  TooltipView.swift
//  SMASHING
//
//  Created by 홍준범 on 3/19/26.
//

import UIKit

import SnapKit
import Then

final class TooltipView: UIView {

    private let bubbleLayer = CAShapeLayer()
    private let messageLabel = UILabel().then {
        $0.textColor = .Text.primaryReverse
        $0.setPretendard(.captionXxsM)
    }

    private let arrowHeight: CGFloat = 6
    private let arrowWidth: CGFloat = 10

    // 툴팁 leading 기준 삼각형 꼭짓점 X 위치
    var arrowTipX: CGFloat = 16 {
        didSet { setNeedsLayout() }
    }

    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let labelSize = messageLabel.intrinsicContentSize
        let width = labelSize.width + 12 * 2
        let height = labelSize.height + arrowHeight + 10 + 10
        return CGSize(width: width, height: height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        drawBubble()
    }

    private func setUI() {
        backgroundColor = .clear

        bubbleLayer.fillColor = UIColor.Background.canvasReverse.cgColor
        bubbleLayer.shadowColor = UIColor.black.cgColor
        bubbleLayer.shadowOpacity = 0.12
        bubbleLayer.shadowOffset = CGSize(width: 0, height: 2)
        bubbleLayer.shadowRadius = 6
        layer.addSublayer(bubbleLayer)
        
        messageLabel.numberOfLines = 0
        addSubview(messageLabel)
    }

    private func setLayout() {
        messageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(arrowHeight + 10)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(10)
        }
    }

    private func drawBubble() {
        let cornerRadius: CGFloat = 8
        let tipX = max(arrowWidth / 2, min(arrowTipX, bounds.width - arrowWidth / 2))
        let bodyTop = arrowHeight
        let bodyRect = CGRect(x: 0, y: bodyTop, width: bounds.width, height: bounds.height - bodyTop)

        let path = UIBezierPath(roundedRect: bodyRect, cornerRadius: cornerRadius)

        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: tipX, y: 0))
        arrowPath.addLine(to: CGPoint(x: tipX - arrowWidth / 2, y: bodyTop))
        arrowPath.addLine(to: CGPoint(x: tipX + arrowWidth / 2, y: bodyTop))
        arrowPath.close()

        path.append(arrowPath)
        bubbleLayer.path = path.cgPath
    }
}
