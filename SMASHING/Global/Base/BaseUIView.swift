//
//  BaseUIView.swift
//  SMASHING
//
//  Created by 이승준 on 12/29/25.
//

import UIKit

class BaseUIView: UIView {

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .Background.canvas
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    func setUI() {}
    func setLayout() {}
}
