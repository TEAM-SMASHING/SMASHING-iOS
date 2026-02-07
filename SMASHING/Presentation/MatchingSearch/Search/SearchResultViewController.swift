//
//  SearchResultViewController.swift
//  SMASHING
//
//  Created by JIN on 1/15/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class SearchResultViewController: BaseViewController {

    // MARK: - Properties

    private let viewModel: SearchResultViewModel
    private let inputSubject = PassthroughSubject<SearchResultViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI Components

    private let searchResultView = SearchResultView()

    // MARK: - Initialize

    init() {
        self.viewModel = SearchResultViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    init(viewModel: SearchResultViewModelProtocol) {
        self.viewModel = viewModel as! SearchResultViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = searchResultView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Background.canvas
        setupTableView()
        setupActions()
        bind()
    }

    // MARK: - Setup Methods

    private func setupTableView() {
        searchResultView.tableView.delegate = self
        searchResultView.tableView.dataSource = self
    }

    private func setupActions() {
        searchResultView.onBackButtonTapped = { [weak self] in
            NavigationManager.shared.pop()
        }
    }

    // MARK: - Bind

    private func bind() {
        let output = viewModel.transform(input: inputSubject.eraseToAnyPublisher())

        output.dataFetched
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.searchResultView.tableView.reloadData()
            }
            .store(in: &cancellables)

        output.isLoading
            .receive(on: DispatchQueue.main)
            .sink { isLoading in
            }
            .store(in: &cancellables)

        output.errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.showErrorAlert(message: message)
            }
            .store(in: &cancellables)

        searchResultView.searchTextField.textDidChangePublisher()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.inputSubject.send(.searchNickname(query))
            }
            .store(in: &cancellables)

        // Navigation binding
        viewModel.navigationEvent.userSelected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userId in
                self?.showUserProfile(userId: userId)
            }
            .store(in: &cancellables)
    }

    // MARK: - Navigation Methods

    private func showUserProfile(userId: String) {
        let sport = KeychainUserSportProvider().currentSport()
        let viewModel = UserProfileViewModel(userId: userId, sport: sport)
        let userProfileVC = UserProfileViewController(viewModel: viewModel)

        viewModel.output.navToMatchManage
            .receive(on: DispatchQueue.main)
            .sink { _ in
                NavigationManager.shared.navigateToMatchManageSentAndRefresh()
            }
            .store(in: &self.cancellables)

        NavigationManager.shared.push(userProfileVC)
    }

    // MARK: - Helper Methods

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension SearchResultViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.searchResults.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultCell.reuseIdentifier,
            for: indexPath
        ) as? SearchResultCell else {
            return UITableViewCell()
        }

        let user = viewModel.searchResults[indexPath.row]
        cell.configure(nickname: user.nickname)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchResultViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let user = viewModel.searchResults[indexPath.row]
        inputSubject.send(.userSelected(user.userId))
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 45
    }
}
