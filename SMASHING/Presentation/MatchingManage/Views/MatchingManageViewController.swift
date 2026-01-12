//
//  MatchingManageViewController.swift
//  SMASHING
//
//  Created by JIN on 1/6/26.
//

import UIKit

import SnapKit
import Then

final class MatchingManageViewController: BaseViewController {
    
    //MARK: - Properties
    
    private var currentTabIndex: Int = 0
    private var categories: [UIViewController] = []
    
    private let headerView = MatchingManageHeaderView()
    
    //MARK: - UI Components
    
    private lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        return pageViewController
    }()

    // MARK: - Lifecycle

    override func setUI() {
        super.setUI()
        self.view.backgroundColor = .systemGreen
    }

    override func setLayout() {
        super.setLayout()
    }

}

extension MatchingManageViewController: UIPageViewControllerDelegate {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed,
              let currentVC = pageViewController.viewControllers?.first,
              let index = self.categories.firstIndex(of: currentVC) else { return }

        self.currentTabIndex = index
        self.headerView.updateSelectedTab(index: index)
    }
}

// MARK: - UIPageViewControllerDataSource

extension MatchingManageViewController: UIPageViewControllerDataSource {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = self.categories.firstIndex(of: viewController),
              index > 0 else { return nil }
        return self.categories[index - 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = self.categories.firstIndex(of: viewController),
              index < self.categories.count - 1 else { return nil }
        return self.categories[index + 1]
    }
}

// MARK: - Preview

import SwiftUI

@available(iOS 18.0, *)
#Preview {
    MatchingManageViewController()
}
