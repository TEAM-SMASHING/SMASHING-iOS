//
//  MatchingManageViewController.swift
//  SMASHING
//
//  Created by JIN on 1/6/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class MatchingManageViewController: BaseViewController {

    //MARK: - Properties

    private var currentTabIndex: MatchingManageHeaderView.Tab = .received
    private var categories: [UIViewController] = []
    private var cancellables = Set<AnyCancellable>()
    private var sentRequestViewController: SentRequestViewController?

    //MARK: - UI Components

    private let matchingManageView = MatchingManageView()

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
        setupCategories()
        setupInitialPage()
        setupHeaderView()
        setupCallbacks()
    }

    //MARK: - SetUp Methods

    override func setUI() {
        self.view.addSubview(matchingManageView)
        matchingManageView.pageViewContainer.addSubview(pageViewController.view)
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
    }
    
    private func setupCategories() {
        let receiveViewModel = ReceiveRequestViewModel()
        let receivedVC = ReceiveRequestViewController(viewModel: receiveViewModel)
        let sentVC = SentRequestViewController(viewModel: SentRequestViewModel())
        let confirmedVC = MatchingConfirmedViewController()
        self.categories = [receivedVC, sentVC, confirmedVC]
        self.sentRequestViewController = sentVC

        receiveViewModel.requestAccepted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.moveToConfirmedTab()
            }
            .store(in: &cancellables)
    }

    private func moveToConfirmedTab() {
        let confirmedTab = MatchingManageHeaderView.Tab.confirmed
        moveToPage(tab: confirmedTab)
        matchingManageView.headerView.updateSelectedTab(confirmedTab)
        if let confirmedVC = categories[confirmedTab.rawValue]
            as? MatchingConfirmedViewController {
            confirmedVC.refresh()
        }
    }
    
    private func setupInitialPage() {
        guard let firstVC = self.categories.first else { return }
        self.pageViewController.setViewControllers(
            [firstVC],
            direction: .forward,
            animated: false,
            completion: nil
        )
    }
    
    private func setupHeaderView() {
        self.matchingManageView.headerView.onTabSelected = { [weak self] tab in
            self?.moveToPage(tab: tab)
        }
    }

    private func setupCallbacks() {
        self.matchingManageView.onBackButtonTapped = { [weak self] in
            NavigationManager.shared.pop()
        }
    }
    
    func moveToPage(tab: MatchingManageHeaderView.Tab) {
        self.matchingManageView.headerView.updateSelectedTab(tab)
        
        guard let currentVC = self.pageViewController.viewControllers?.first,
              let currentIndex = self.categories.firstIndex(of: currentVC),
              currentIndex != tab.rawValue else { return }
        
        let targetVC = self.categories[tab.rawValue]
        let direction: UIPageViewController.NavigationDirection = currentIndex < tab.rawValue ? .forward : .reverse
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.pageViewController.setViewControllers(
                [targetVC],
                direction: direction,
                animated: true,
                completion: { finished in
                    if finished {
                        self?.currentTabIndex = tab
                    }
                }
            )
        }
    }

    func refreshSentRequests() {
        sentRequestViewController?.refresh()
    }
    
    override func setLayout() {
        matchingManageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        pageViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        self.matchingManageView.headerView.updateSelectedTab(tab)
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
