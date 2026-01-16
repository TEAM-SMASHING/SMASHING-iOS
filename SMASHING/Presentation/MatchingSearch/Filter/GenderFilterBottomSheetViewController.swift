//
//  GenderFilterBottomSheetViewController.swift
//  SMASHING
//
//  Created by JIN on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class GenderFilterBottomSheetViewController: BaseViewController {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.text = "성별"
        $0.font = .pretendard(.subtitleLgSb)
        $0.textColor = .Text.primary
    }
    
    private lazy var tableView = UITableView().then {
        $0.backgroundColor = .Background.surface
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.register(
            GenderFilterTableViewCell.self,
            forCellReuseIdentifier: GenderFilterTableViewCell.reuseIdentifier
        )
    }
    
    private lazy var confirmButton = UIButton().then {
        $0.setTitle("적용하기", for: .normal)
        $0.titleLabel?.font = .pretendard(.subtitleLgSb)
        $0.setTitleColor(.Button.textPrimaryDisabled, for: .normal)
        $0.backgroundColor = .Button.backgroundPrimaryDisabled
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Properties
    
    private let genderList: [String] = ["남성", "여성", "남녀 모두"]
    private var selectedGender: String?
    var onGenderSelected: ((String) -> Void)?
    
    // MARK: - Setup Methods
    
    override func setUI() {
        view.backgroundColor = .Background.surface
        view.addSubviews(
            titleLabel,
            tableView,
            confirmButton
        )
    }
    
    override func setLayout() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(confirmButton.snp.top)
        }
        
        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(46)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: - Actions
    
    @objc private func confirmButtonDidTap() {
        if let selectedGender = self.selectedGender {
            onGenderSelected?(selectedGender)
        }
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension GenderFilterBottomSheetViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return self.genderList.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GenderFilterTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? GenderFilterTableViewCell else {
            return UITableViewCell()
        }
        let gender = self.genderList[indexPath.row]
        let isSelected = gender == self.selectedGender
        cell.configure(gender: gender, isSelected: isSelected)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension GenderFilterBottomSheetViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let gender = self.genderList[indexPath.row]
        self.selectedGender = gender
        tableView.reloadData()

        confirmButton.isEnabled = true
        confirmButton.backgroundColor = .Button.backgroundPrimaryActive
        confirmButton.setTitleColor(.Button.textPrimaryActive, for: .normal)
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 55
    }
}
