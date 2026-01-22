import UIKit
import SnapKit
import Then

final class SubmitConfirmAlertView: UIView {

    var onConfirm: (() -> Void)?
    var onCancel: (() -> Void)?

    private let dimView = UIView().then {
        $0.backgroundColor = .Background.dimmed
    }

    private let containerView = UIView().then {
        $0.backgroundColor = .Background.surfacePressed
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }

    private let titleLabel = UILabel().then {
        $0.text = "매칭 결과를 제출하시겠습니까?"
        $0.font = .pretendard(.textMdSb)
        $0.textColor = .Text.primary
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    private let subtitleLabel = UILabel().then {
        $0.text = "정확한 경기 결과가 아닐 경우 반려될 수 있어요."
        $0.font = .pretendard(.textSmR)
        $0.textColor = .Text.tertiary
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    private let cancelButton = UIButton(type: .system).then {
        $0.setTitle("아니요", for: .normal)
        $0.titleLabel?.font = .pretendard(.textSmR)
        $0.setTitleColor(.Button.textSecondaryActive, for: .normal)
        $0.backgroundColor = .Button.backgroundTeritaryActive
        $0.layer.cornerRadius = 10
    }

    private let confirmButton = UIButton(type: .system).then {
        $0.setTitle("제출하기", for: .normal)
        $0.titleLabel?.font = .pretendard(.textSmR)
        $0.setTitleColor(.Button.textSecondaryActive, for: .normal)
        $0.backgroundColor = .Button.backgroundSecondaryActive
        $0.layer.cornerRadius = 10
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear

        addSubview(dimView)
        dimView.addSubview(containerView)
        containerView.addSubviews(titleLabel, subtitleLabel, cancelButton, confirmButton)
    }

    private func setupLayout() {
        dimView.snp.makeConstraints { $0.edges.equalToSuperview() }

        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(28)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(32)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        cancelButton.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview().inset(24)
        }

        confirmButton.snp.makeConstraints {
            $0.top.equalTo(cancelButton)
            $0.leading.equalTo(cancelButton.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(cancelButton)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview().inset(24)
        }
    }

    private func setupActions() {
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapDim))
        dimView.addGestureRecognizer(tap)
    }

    @objc private func didTapCancel() {
        onCancel?()
        removeFromSuperview()
    }

    @objc private func didTapConfirm() {
        onConfirm?()
        removeFromSuperview()
    }

    @objc private func didTapDim() {
        onCancel?()
        removeFromSuperview()
    }
    
    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
