//
//  SearchResultViewController.swift
//  SMASHING
//
//  Created by JIN on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class SearchResultViewController: BaseViewController {

    //MARK: - UIComponents

    private let searchResultView = SearchResultView()

    // MARK: - Lifecycle

    override func loadView() {
        view = searchResultView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Background.canvas
        setupTableView()
        setupActions()
    }

    // MARK: - Setup Methods

    private func setupTableView() {
        searchResultView.tableView.delegate = self
        searchResultView.tableView.dataSource = self
        searchResultView.searchTextField.delegate = self
    }

    private func setupActions() {
        searchResultView.onBackButtonTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension SearchResultViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 10
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultCell.reuseIdentifier,
            for: indexPath
        )
        cell.textLabel?.font = .pretendard(.textMdM)
        cell.textLabel?.textColor = .Text.primary
        cell.backgroundColor = .Background.canvas
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchResultViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 45
    }
}

// MARK: - UITextFieldDelegate

extension SearchResultViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchText = textField.text, !searchText.isEmpty else {
            return true
        }
        textField.resignFirstResponder()
        return true
    }
}
