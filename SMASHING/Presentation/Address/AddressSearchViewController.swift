//
//  AddressSearchController.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

import Combine
import UIKit

enum AddressSelectionMode {
    case onboarding
    case changeRegion
}

final class AddressSearchViewController: BaseViewController {

    // MARK: - Properties

    let mainView = AddressSearchView()

    var onAddressSelected: ((String) -> Void)?

    private let viewModel: AddressSearchViewModel
    private let mode: AddressSelectionMode
    private let inputSubject = PassthroughSubject<AddressSearchViewModel.Input, Never>()
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init

    init(mode: AddressSelectionMode) {
        let service = KakaoAddressService()
        self.viewModel = AddressSearchViewModel(addressService: service)
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
        self.hideKeyboardWhenDidTap()
    }

    init(viewModel: any AddressSearchViewModelProtocol) {
        self.viewModel = viewModel as! AddressSearchViewModel
        self.mode = .onboarding
        super.init(nibName: nil, bundle: nil)
        self.hideKeyboardWhenDidTap()
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        self.view = mainView
        setDelegate()
        bind()
        setActions()
    }

    private func setDelegate() {
        mainView.resultCollectionView.dataSource = self
        mainView.resultCollectionView.delegate = self
    }

    private func setActions() {
        mainView.backAction = { [weak self] in
            guard let self else { return }
            inputSubject.send(.backTapped)
        }
    }

    func bind() {
        let output = viewModel.transform(input: inputSubject.eraseToAnyPublisher())

        output.dataFetched
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.mainView.resultCollectionView.reloadData()
            }
            .store(in: &cancellables)

        mainView.searchTextField.textDidChangePublisher()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.inputSubject.send(.searchAddress(query))
            }
            .store(in: &cancellables)

        mainView.resultCollectionView
            .reachedBottomPublisher
            .sink { [weak self] _ in
                self?.inputSubject.send(.reachedBottom)
            }
            .store(in: &cancellables)

        output.navBackTapped
            .receive(on: DispatchQueue.main)
            .sink { _ in
                NavigationManager.shared.pop()
            }
            .store(in: &cancellables)

        output.navAddressSelected
            .map { $0.replacingOccurrences(of: "서울 ", with: "") }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] address in
                guard let self else { return }
                self.onAddressSelected?(address)
                if self.mode == .changeRegion {
                    NavigationManager.shared.pop()
                }
            }
            .store(in: &cancellables)
    }
}

extension AddressSearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddressSearchResultCell.reuseIdentifier, for: indexPath) as? AddressSearchResultCell else {
            return UICollectionViewCell()
        }
        cell.configure(address: viewModel.searchResults[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 55)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputSubject.send(.addressSelected(viewModel.searchResults[indexPath.item]))
    }
}
