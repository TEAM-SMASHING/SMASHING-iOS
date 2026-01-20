//
//  ReceiveRequestViewController.swift
//  SMASHING
//
//  Created by JIN on 1/12/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class ReceiveRequestViewController: BaseViewController {

    // MARK: - Properties

    private let viewModel: any ReceiveRequestViewModelProtocol
    private let input = PassthroughSubject<ReceiveRequestViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()

    private var requestList: [ReceiveRequestResultDTO] = []

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
        collectionView.register(ReceiveRequestCell.self, forCellWithReuseIdentifier: ReceiveRequestCell.reuseIdentifier)
        return collectionView
    }()

    private let emptyLabel = UILabel().then {
        $0.text = "받은 요청이 없습니다"
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

    init(viewModel: ReceiveRequestViewModel = ReceiveRequestViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        _ = KeychainService.add(key:Environment.accessTokenKey , value: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIwUDZWVksyRk1HNEZYIiwidHlwZSI6IkFDQ0VTU19UT0tFTiIsInJvbGVzIjpbXSwiaWF0IjoxNzY4NjU5ODE1LCJleHAiOjEyMDk3NzY4NjU5ODE1fQ.9Hao_dtvvKs-1D2Rdy7C6RGcREFQMo2JXqapTOajNoc")
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

        output.requestList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] requests in
                guard let self else { return }
                self.requestList = requests
                self.collectionView.reloadData()
                self.emptyLabel.isHidden = !requests.isEmpty
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

        collectionView.reachedBottomPublisher
            .sink { [weak self] in
                self?.input.send(.loadMore)
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    private func skipButtonDidTap(at index: Int) {
        input.send(.skipTapped(index: index))
    }

    private func acceptButtonDidTap(at index: Int) {
        input.send(.acceptTapped(index: index))
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

extension ReceiveRequestViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.requestList.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ReceiveRequestCell.reuseIdentifier,
            for: indexPath
        ) as? ReceiveRequestCell else {
            return UICollectionViewCell()
        }

        let request = self.requestList[indexPath.row]
        cell.configure(with: request.requester)

        cell.onSkipTapped = { [weak self] in
            self?.skipButtonDidTap(at: indexPath.item)
        }

        cell.onAcceptTapped = { [weak self] in
            self?.acceptButtonDidTap(at: indexPath.item)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ReceiveRequestViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (collectionView.frame.width - 43) / 2
        let height: CGFloat = 224
        return CGSize(width: width, height: height)
    }
}
