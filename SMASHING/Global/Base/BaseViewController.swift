//
//  BaseViewController.swift
//  SMASHING
//
//  Created by 이승준 on 12/29/25.
//

import UIKit
import Then

class BaseViewController: UIViewController, ToastDisplayable {
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Background.canvas
        setUI()
        setLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - Setup Methods
    
    func setUI() {}
    func setLayout() {}
    
    func showToast(type: SseEventType) {
        let toast = ToastMessage()
        if let navView = self.navigationController?.view {
            navView.addSubview(toast)
            navView.bringSubviewToFront(toast)
        } else {
            self.view.addSubview(toast)
        }
        toast.configure(title: type.displayText)
        toast.show()
    }
}
