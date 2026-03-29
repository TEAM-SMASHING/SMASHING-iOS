//
//  SplashViewController.swift
//  SMASHING
//

import UIKit

import SnapKit
import Then

final class SplashViewController: UIViewController {

    // MARK: - UI Components

    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "splash_logo")
        $0.contentMode = .scaleAspectFit
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Background.canvas
        setLayout()
    }

    // MARK: - Layout

    private func setLayout() {
        view.addSubview(logoImageView)

        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(240)
        }
    }
}
