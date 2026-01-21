//
//  MatchingConfirmedViewController.swift
//  SMASHING
//
//  Created by JIN on 1/12/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class MatchingConfirmedViewController: BaseViewController {

    // MARK: - Properties

    private let viewModel: MatchingConfirmedViewModel
    private let input = PassthroughSubject<MatchingConfirmedViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()

    private var gameList: [MatchingConfirmedGameDTO] = []

    // MARK: - UI Components

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 11
        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(MatchingConfirmedCell.self, forCellWithReuseIdentifier: MatchingConfirmedCell.reuseIdentifier)
        return collectionView
    }()

    private let emptyLabel = UILabel().then {
        $0.text = "확정된 매칭이 없습니다"
        $0.font = .pretendard(.textMdM)
        $0.textColor = .Text.tertiary
        $0.textAlignment = .center
        $0.isHidden = true
    }

    private let loadingIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.hidesWhenStopped = true
        $0.color = .Text.secondary
    }

    // MARK: - Initialize

    init(viewModel: MatchingConfirmedViewModel = MatchingConfirmedViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        input.send(.viewDidLoad)
    }

    // MARK: - Setup Methods

    override func setUI() {
        view.backgroundColor = UIColor(resource: .Background.canvas)
        view.addSubviews(collectionView, emptyLabel, loadingIndicator)
    }

    override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    // MARK: - Bind

    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output.gameList
            .combineLatest(output.isLoading)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] games, isLoading in
                guard let self else { return }
                self.gameList = games
                self.collectionView.reloadData()
                self.emptyLabel.isHidden = isLoading || !games.isEmpty
            }
            .store(in: &cancellables)

        output.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    self.loadingIndicator.startAnimating()
                } else {
                    self.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)

        output.isLoadingMore
            .receive(on: DispatchQueue.main)
            .sink { _ in }
            .store(in: &cancellables)

        output.errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.showErrorToast(message: message)
            }
            .store(in: &cancellables)

        output.itemRemoved
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.emptyLabel.isHidden = !self.gameList.isEmpty
            }
            .store(in: &cancellables)

        collectionView.reachedBottomPublisher
            .sink { [weak self] in
                self?.input.send(.loadMore)
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    func refresh() {
        input.send(.refresh)
    }

    private func closeButtonDidTap(at index: Int) {
        let popup = ConfirmPopupViewController(
            title: "정말 매칭을 취소하시겠어요?",
            message: "매칭 상대도 동의해야 취소가 완료돼요.",
            cancelTitle: "아니요",
            confirmTitle: "취소하기"
        )

        popup.onConfirmTapped = { [weak self] in
            self?.input.send(.closeTapped(index: index))
        }

        present(popup, animated: true)
    }

    // MARK: - Helper Methods

    private func showErrorToast(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension MatchingConfirmedViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return self.gameList.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MatchingConfirmedCell.reuseIdentifier,
            for: indexPath
        ) as? MatchingConfirmedCell else {
            return UICollectionViewCell()
        }

        let game = self.gameList[indexPath.row]
        cell.configure(with: game)

        cell.onCloseTapped = { [weak self] in
            self?.closeButtonDidTap(at: indexPath.item)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MatchingConfirmedViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (collectionView.frame.width - 43) / 2
        let height: CGFloat = 222
        return CGSize(width: width, height: height)
    }
}
