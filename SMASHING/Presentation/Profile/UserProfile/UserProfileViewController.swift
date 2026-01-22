//
//  UserProfileViewController.swift
//  SMASHING
//
//  Created by 이승준 on 1/16/26.
//

import UIKit
import Combine

import SnapKit
import Then

final class UserProfileViewController: UIViewController {

    // MARK: - Properties

    private let mainView = UserProfileView()
    private let viewModel: UserProfileViewModelProtocol
    private let input = PassthroughSubject<UserProfileViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(viewModel: UserProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        mainView.backAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        mainView.challengeAction = { [weak self] in
            self?.presentChallengePopup()
        }

        mainView.reviewCard.reviewCollectionView.delegate = self
        mainView.reviewCard.reviewCollectionView.dataSource = self

        bind()
        input.send(.viewDidLoad)
    }

    // MARK: - Bind

    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output.userProfile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] profile in
                guard let self, let profile else { return }
                self.updateUI(with: profile)
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
                print("Error: \(message)")
            }
            .store(in: &cancellables)

        output.challengeRequestCompleted
            .receive(on: DispatchQueue.main)
            .sink { }
            .store(in: &cancellables)
    }

    // MARK: - Private Methods

    private func updateUI(with profile: OtherUserProfileResponse) {
        mainView.configure(with: profile, mode: .plain)
        mainView.reviewCard.reviewCollectionView.reloadData()
    }

    private func presentChallengePopup() {
        let popup = ConfirmPopupViewController(
            title: "경쟁 신청이 완료되었습니다!",
            message: "매칭 관리 탭에서 매칭 정보를 확인해주세요.",
            cancelTitle: "확인",
            confirmTitle: "바로가기"
        )
        popup.onConfirmTapped = { [weak self] in
            self?.input.send(.challengeConfirmed)
        }
        present(popup, animated: true)
    }
}

extension UserProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.reviewPreviews.count > 3 ? 3 : viewModel.reviewPreviews.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ReviewCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? ReviewCollectionViewCell else { return UICollectionViewCell() }
        
        let data = viewModel.reviewPreviews[indexPath.item]
        
        cell.configure(data)
        
        cell.contentView.snp.remakeConstraints {
            $0.width.equalTo(collectionView.frame.width)
        }

        return cell
    }
}
