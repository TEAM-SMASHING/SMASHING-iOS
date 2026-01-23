//
//  SentRequestViewController.swift
//  SMASHING
//
//  Created by JIN on
import UIKit

import Combine
import SnapKit
import Then

final class SentRequestViewController: BaseViewController {

    // MARK: - Properties

    private let viewModel: SentRequestViewModel
    private let input = PassthroughSubject<SentRequestViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var requestList: [SentRequestResultDTO] = []

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
        collectionView.register(SentRequestCell.self, forCellWithReuseIdentifier: SentRequestCell.reuseIdentifier)
        return collectionView
    }()

    private let emptyLabel = UILabel().then {
        $0.text = "보낸 요청이 없습니다"
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

    init(viewModel: SentRequestViewModel = SentRequestViewModel()) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        bind()
        input.send(.refresh)
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

        output.requestList
            .combineLatest(output.isLoading)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] requests, isLoading in
                guard let self else { return }
                self.requestList = requests
                self.collectionView.reloadData()
                self.emptyLabel.isHidden = isLoading || !requests.isEmpty
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
                self.emptyLabel.isHidden = !self.requestList.isEmpty
            }
            .store(in: &cancellables)

        collectionView.reachedBottomPublisher
            .sink { [weak self] in
                self?.input.send(.loadMore)
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    private func closeButtonDidTap(at index: Int) {
        let popup = ConfirmPopupViewController(
            title: "요청을 취소하시겠습니까?",
            message: "요청 취소 시 24시간 후 재요청할 수 있습니다",
            cancelTitle: "아니요",
            confirmTitle: "취소하기"
        )

        popup.onConfirmTapped = { [weak self] in
            self?.input.send(.closeTapped(index: index))
        }

        present(popup, animated: true)
    }

    func refresh() {
        input.send(.refresh)
    }

    // MARK: - Helper Methods

    private func showErrorToast(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension SentRequestViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.requestList.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SentRequestCell.reuseIdentifier,
            for: indexPath
        ) as? SentRequestCell else {
            return UICollectionViewCell()
        }

        let reversedIndex = self.requestList.count - 1 - indexPath.item
        let request = self.requestList[reversedIndex]
        cell.configure(with: request.receiver)

        cell.onCloseTapped = { [weak self] in
            self?.closeButtonDidTap(at: reversedIndex)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SentRequestViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (collectionView.frame.width - 43) / 2
        let height: CGFloat = 203
        return CGSize(width: width, height: height)
    }
}
