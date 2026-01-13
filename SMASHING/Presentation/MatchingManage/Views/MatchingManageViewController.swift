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
    
    private var currentTabIndex: MatchingManageHeaderView.Tab = .received
    private var categories: [UIViewController] = []
        
    //MARK: - UI Components

    private lazy var navigationBar = CustomNavigationBar(title: "매칭 관리") { [weak self] in
        self?.navigationController?.popViewController(animated: true)
    }

    private let headerView = MatchingManageHeaderView()

    private lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    ).then {
        $0.dataSource = self
        $0.delegate = self
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - SetUp Methods
    
    override func setUI() {
        super.setUI()
        self.view.backgroundColor = UIColor(resource: .Background.canvas)
        navigationBar.setLeftButtonHidden(true)
        view.addSubviews(navigationBar, headerView, pageViewController.view)
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
    }

    override func setLayout() {
        super.setLayout()

        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        headerView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }

        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
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
              let index = self.categories.firstIndex(of: currentVC),
              let tab = MatchingManageHeaderView.Tab(rawValue: index) else { return }
        
        self.currentTabIndex = tab
        self.headerView.updateSelectedTab(tab)
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
