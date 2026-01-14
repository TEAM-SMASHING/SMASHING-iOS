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

    //MARK: - Properties

    private var allNicknames: [String] = []
    private var filteredNicknames: [String] = []
    private var recentSearches: [String] = []

    // MARK: - Lifecycle

    override func loadView() {
        view = searchResultView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Background.canvas
        setupTableView()
        setupActions()
        loadData()
    }

    // MARK: - Setup Methods

    private func setupTableView() {
        searchResultView.tableView.delegate = self
        searchResultView.tableView.dataSource = self
        searchResultView.searchTextField.delegate = self
        searchResultView.searchTextField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
    }

    private func setupActions() {
        searchResultView.onBackButtonTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    private func loadData() {
        // Mock 데이터에서 닉네임 추출
        allNicknames = ["윤서", "민준", "지우", "서준", "하은", "도윤", "수아", "예준", "시우", "아린", "준우", "채원"]
        filteredNicknames = Array(allNicknames.prefix(5)).sorted()
        recentSearches = filteredNicknames
    }

    // MARK: - Helper Methods

    private func filterNicknames(with searchText: String) {
        if searchText.isEmpty {
            filteredNicknames = Array(recentSearches.prefix(5)).sorted()
            searchResultView.updateStatusLabel(text: "최근 5개 노출 (가나다순)")
        } else {
            filteredNicknames = allNicknames.filter { $0.contains(searchText) }.sorted()
            searchResultView.updateStatusLabel(text: "검색어 입력")
        }
        searchResultView.tableView.reloadData()
    }

    private func performSearch(with nickname: String) {
        // 최근 검색어에 추가
        if !recentSearches.contains(nickname) {
            recentSearches.insert(nickname, at: 0)
            if recentSearches.count > 5 {
                recentSearches.removeLast()
            }
        }

        // 검색 결과로 필터링된 메인 화면으로 돌아가기
        print("검색: \(nickname)")
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension SearchResultViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return filteredNicknames.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "SearchResultCell",
            for: indexPath
        )
        cell.textLabel?.text = filteredNicknames[indexPath.row]
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
        let selectedNickname = filteredNicknames[indexPath.row]
        performSearch(with: selectedNickname)
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 44
    }
}

// MARK: - UITextFieldDelegate

extension SearchResultViewController: UITextFieldDelegate {

    @objc private func textFieldDidChange() {
        let searchText = searchResultView.searchTextField.text ?? ""
        filterNicknames(with: searchText)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchText = textField.text, !searchText.isEmpty else {
            return true
        }
        performSearch(with: searchText)
        textField.resignFirstResponder()
        return true
    }
}
