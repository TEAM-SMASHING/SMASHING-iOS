//
//  RejectReasonBottomSheetViewController.swift
//  SMASHING
//
//  Created by 홍준범 on 1/21/26.
//

import UIKit

import SnapKit
import Then

// MARK: - RejectReason

enum RejectReason: String, CaseIterable {
    case wrongScore = "SCORE_MISMATCH"
    case wrongWinner = "WIN_LOSE_REVERSED"
    case wrongBoth = "SCORE_AND_WIN_LOSE_MISMATCH"
    case notPlayed = "GAME_NOT_PLAYED_YET"
    
    var displayText: String {
        switch self {
        case .wrongScore:
            return "스코어가 잘못됐어요"
        case .wrongWinner:
            return "승자가 잘못됐어요"
        case .wrongBoth:
            return "스코어와 승자 모두 잘못됐어요"
        case .notPlayed:
            return "아직 진행하지 않은 경기예요"
        }
    }
}

final class RejectReasonBottomSheetViewController: BaseViewController {
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.text = "어떤 내용이 잘못됐나요?"
        $0.font = .pretendard(.subtitleLgSb)
        $0.textColor = .Text.primary
    }
    
    private lazy var tableView = UITableView().then {
        $0.backgroundColor = .Background.surface
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.register(
            RejectReasonTableViewCell.self,
            forCellReuseIdentifier: RejectReasonTableViewCell.reuseIdentifier
        )
    }
    
    private lazy var submitButton = UIButton().then {
        $0.setTitle("제출하기", for: .normal)
        $0.titleLabel?.font = .pretendard(.subtitleLgSb)
        $0.setTitleColor(.Button.textPrimaryDisabled, for: .normal)
        $0.backgroundColor = .Button.backgroundPrimaryDisabled
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(submitButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Properties
    
    private let reasons = RejectReason.allCases
    private var selectedReason: RejectReason?
    var onReasonSelected: ((RejectReason) -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        view.backgroundColor = .Background.surface
        view.addSubviews(titleLabel, tableView, submitButton)
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(submitButton.snp.top).offset(-16)
        }
        
        submitButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(46)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc
    private func submitButtonDidTap() {
        guard let selectedReason = self.selectedReason else { return }
        onReasonSelected?(selectedReason)
        print("selectedReason\(selectedReason)")
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension RejectReasonBottomSheetViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RejectReasonTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? RejectReasonTableViewCell else {
            return UITableViewCell()
        }
        let reason = reasons[indexPath.row]
        let isSelected = reason == selectedReason
        cell.configure(reason: reason, isSelected: isSelected)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension RejectReasonBottomSheetViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedReason = reasons[indexPath.row]
        tableView.reloadData()
        
        submitButton.isEnabled = true
        submitButton.backgroundColor = .Button.backgroundPrimaryActive
        submitButton.setTitleColor(.Button.textPrimaryActive, for: .normal)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
