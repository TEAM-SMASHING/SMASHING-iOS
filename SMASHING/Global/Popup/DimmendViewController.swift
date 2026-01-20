//
//  DimmendViewController.swift
//  GreenStep
//
//  Created by JIN on 7/29/25.
//

import UIKit

import SnapKit
import Then

class DimmedViewController: UIViewController {
    
    //MARK: -Properties
    
    private let dimmedView = UIView()
        
    //MARK: - initialize
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .coverVertical
        modalPresentationStyle = .overFullScreen
    }
    
    required public init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: -LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let presentingViewController else { return }
        
        dimmedView.backgroundColor = .Background.dimmed
        dimmedView.alpha = 0
        presentingViewController.view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = 0.25
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dimmedView.removeFromSuperview()
        }
    }
    
}
