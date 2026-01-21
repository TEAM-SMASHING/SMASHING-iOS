//
//  AddressSearchViewModel.swift
//  SMASHING
//
//  Created by 이승준 on 1/20/26.
//

import Combine
import Foundation

protocol AddressSearchViewModelProtocol: InputOutputProtocol where Input == AddressSearchViewModel.Input, Output == AddressSearchViewModel.Output {
    var searchResults: [String] {get}
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
        case addressSelected(String)
        case backTapped
    }
    
    struct Output {
        let dataFetched = PassthroughSubject<Void, Never>()
        let navBackTapped = PassthroughSubject<Void, Never>()
        let navAddressSelected = PassthroughSubject<String, Never>()
    }
    
    let output = Output()
    
    let addressService: KakaoAddressServiceProtocol
    
    init(addressService: KakaoAddressServiceProtocol) {
        self.addressService = addressService
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> Output {
        let inputShared = input.share()
        
        inputShared
            .compactMap { event -> String? in
                if case let .searchAddress(query) = event { return query }
                return nil
            }
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.handleSearch(query)
            }
            .store(in: &cancellables)
        
        inputShared
            .sink { [weak self] event in
                switch event {
                case .reachedBottom:
                    self?.handleLoadNextPage()
                case .addressSelected(let address):
                    self?.output.navAddressSelected.send(address.replacingOccurrences(of: "서울 ", with: ""))
                case .backTapped:
                    self?.output.navBackTapped.send()
                case .searchAddress:
                    break
                }
            }
            .store(in: &cancellables)
        return output
    }
    
    private func handleSearch(_ query: String) {
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
                self?.isFetching = false
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.searchResults = response.documents
                    .filter { $0.address?.region1depthName.contains("서울") ?? false }
                    .map { $0.addressName }
                
                self.output.dataFetched.send()
                self.isFetching = false
            })
            .store(in: &cancellables)
    }

    private func handleLoadNextPage() {
        guard !isFetching, !currentQuery.isEmpty else { return }
        self.searchCurrentPage += 1
    }
}
