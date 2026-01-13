//
//  HomViewController.swift
//  SMASHING
//
//  Created by JIN on 1/6/26.
//

import UIKit

final class HomeViewController: BaseViewController {

    // MARK: - Lifecycle

    override func setUI() {
        super.setUI()
        self.view.backgroundColor = .systemRed
    }

    override func setLayout() {
        super.setLayout()
    }

}

// MARK: - Preview

import SwiftUI

@available(iOS 18.0, *)
#Preview {
    HomeViewController()
}
