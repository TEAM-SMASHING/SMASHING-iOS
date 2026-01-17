//
//  AddressSearchController.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

import Combine

protocol AddressSearchViewModelProtocol: InputOutputProtocol where Input == AddressSearchViewModel.Input, Output == AddressSearchViewModel.Output {
    var searchResults: [String] {get}
    associatedtype NavigationEvent
    var navigationEvent: NavigationEvent {get}
}

final class AddressSearchViewModel: AddressSearchViewModelProtocol {
    
    var searchResults: [String] = []
    var searchCurrentPage: Int = 1
    private var isFetching = false
    private var currentQuery: String = ""
    private var cancellables: Set<AnyCancellable> = []
    
    enum Input {
        case searchAddress(String)
        case reachedBottom
        case backTapped(String)
    }
    
    struct Output {
        let dataFetched = PassthroughSubject<Void, Never>()
    }
    
    struct NavigationEvent {
        let backTapped = PassthroughSubject<String, Never>()
    }
    
    let output = Output()
    let navigationEvent = NavigationEvent()
    
    let addressService: KakaoAddressServiceProtocol
    
    init(addressService: KakaoAddressServiceProtocol) {
        self.addressService = addressService
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> Output {
        input
            .sink { [weak self] event in
                switch event {
                case .searchAddress(let query):
                    self?.handleSearch(query)
                case .reachedBottom:
                    self?.handleLoadNextPage()
                case .backTapped(let address):
                    self?.navigationEvent.backTapped.send(address)
                }
            }
            .store(in: &cancellables)
            
        return output
    }
    
    private func handleSearch(_ query: String) {
        guard !isFetching else { return }
        guard !query.isEmpty else {
            self.searchResults = []
            self.output.dataFetched.send()
            return
        }
        
        isFetching = true
        self.currentQuery = query
        self.searchCurrentPage = 1
        
        addressService.searchAddress(query: query)
            .sink(receiveCompletion: { [weak self] _ in
                guard let self else { return }
                isFetching = false
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                searchResults = response.documents
                    .filter { $0.address?.region1depthName.contains("서울") ?? false }
                    .map { $0.addressName }
                output.dataFetched.send()
                isFetching = false
            })
            .store(in: &cancellables)
    }

    private func handleLoadNextPage() {
        self.searchCurrentPage += 1
    }
}
import UIKit

final class AddressSearchViewController: BaseViewController {
    
    // MARK: - Properties
    
    let mainView = AddressSearchView()
    
    private let viewModel: any AddressSearchViewModelProtocol
    private let inputSubject = PassthroughSubject<AddressSearchViewModel.Input, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: any AddressSearchViewModelProtocol) {
        self.viewModel = viewModel
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
    }
    
    private func setDelegate() {
        mainView.resultCollectionView.dataSource = self
        mainView.resultCollectionView.delegate = self
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
        inputSubject.send(.backTapped(viewModel.searchResults[indexPath.item].replacingOccurrences(of: "서울 ", with: "")))
    }
}
