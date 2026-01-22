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
    
    private var myUserId: String {
        return KeychainService.get(key: Environment.userIdKey) ?? ""
    }
    
    private var myNickname: String {
        return KeychainService.get(key: Environment.nicknameKey) ?? ""
    }

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        output.navToMatchResultConfirm
            .receive(on: DispatchQueue.main)
            .sink { [weak self] gameData in
                self?.navigateToMatchResultConfirm(gameData: gameData)
            }
            .store(in: &cancellables)
        
        output.navToMatchResultCreate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] gameData in
                self?.showMatchResultCreate(with: gameData)
            }
            .store(in: &cancellables)
    }
    
    private func navigateToMatchResultConfirm(gameData: MatchingConfirmedGameDTO) {
        guard let submissionId = gameData.latestSubmissionId else { return }
        let viewModel = MatchResultConfirmViewModel(
            gameData: gameData,
            submissionId: submissionId,
            myUserId: myUserId
        )
        let vc = MatchResultConfirmViewController(viewModel: viewModel)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showMatchResultCreate(with gameData: MatchingConfirmedGameDTO) {
        let vm = MatchResultCreateViewModel(gameData: gameData, myUserId: myUserId, myNickname: myNickname)
        let vc = MatchResultCreateViewController(viewModel: vm)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
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
        cell.configure(with: game, myUserId: myUserId)

        cell.onCloseTapped = { [weak self] in
            self?.closeButtonDidTap(at: indexPath.item)
        }
        cell.onAcceptTapped = { [weak self] in
            guard let self else { return }
            let isMySubmission = game.latestSubmitterId == self.myUserId
            let canConfirm = game.resultStatus.canConfirm(isMySubmission: isMySubmission)
            if canConfirm {
                // 상대방이 제출한 결과 확인 플로우
                self.input.send(.matchingResultConfirmButtonTapped(game))
            } else {
                // 결과 작성 플로우
                self.input.send(.matchingResultCreateButtonTapped(game))
            }
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
