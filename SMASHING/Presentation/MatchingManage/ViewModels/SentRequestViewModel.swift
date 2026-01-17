//
//  SentRequestViewModel.swift
//  SMASHING
//
//  Created by Claude on 1/17/26.
//

import Foundation
import Combine

// MARK: - Protocol

protocol SentRequestViewModelProtocol: InputOutputProtocol
where Input == SentRequestViewModel.Input, Output == SentRequestViewModel.Output {}

// MARK: - ViewModel

final class SentRequestViewModel: SentRequestViewModelProtocol {
    
    // MARK: - Input/Output Types
    
    enum Input {
        case viewDidLoad
        case refresh
        case closeTapped(index: Int)
    }
    
    struct Output {
        let requestList: AnyPublisher<[SentRequestResultDTO], Never>
        let isLoading: AnyPublisher<Bool, Never>
        let errorMessage: AnyPublisher<String, Never>
        let itemRemoved: AnyPublisher<Int, Never>
    }
    
    // MARK: - Private Subjects
    
    private let requestListSubject = CurrentValueSubject<[SentRequestResultDTO], Never>([])
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorMessageSubject = PassthroughSubject<String, Never>()
    private let itemRemovedSubject = PassthroughSubject<Int, Never>()
    
    // MARK: - Public Subjects
    
    let requestCancelled = PassthroughSubject<Void, Never>()
    let refreshFromParent = PassthroughSubject<Void, Never>()
    
    // MARK: - Properties
    
    private let service: SentRequestServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var lastRefreshTime: Date?
    
    //MARK: - Initilalize
    
    init(service: SentRequestServiceProtocol = MockSentRequestService()) {
        self.service = service
    }
    
    // MARK: - Transform
    
    func transform(input: AnyPublisher<Input, Never>) -> Output {
        input
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .viewDidLoad:
                    self.fetchSentList()
                    
                case .refresh:
                    self.handleRefresh()
                    
                case .closeTapped(let index):
                    self.cancelRequest(at: index)
                }
            }
            .store(in: &cancellables)
        
        refreshFromParent
            .sink { [weak self] in
                self?.fetchSentList()
            }
            .store(in: &cancellables)
        
        return Output(
            requestList: requestListSubject.eraseToAnyPublisher(),
            isLoading: isLoadingSubject.eraseToAnyPublisher(),
            errorMessage: errorMessageSubject.eraseToAnyPublisher(),
            itemRemoved: itemRemovedSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Private Methods
    
    private func handleRefresh() {
        // Throttling: 0.5초 이내 재요청 방지
        let now = Date()
        if let lastTime = lastRefreshTime, now.timeIntervalSince(lastTime) < 0.5 {
            return
        }
        lastRefreshTime = now
        fetchSentList()
    }
    
    private func fetchSentList() {
        isLoadingSubject.send(true)
        
        service.getSentRequestList { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.isLoadingSubject.send(false)
                
                switch result {
                case .success(let dto):
                    self.requestListSubject.send(dto.requests)
                    
                case .pathError:
                    self.errorMessageSubject.send("데이터를 불러오는데 실패했습니다.")
                    
                case .networkError:
                    self.errorMessageSubject.send("네트워크 연결을 확인해주세요.")
                }
            }
        }
    }
    
    private func cancelRequest(at index: Int) {
            guard index < requestListSubject.value.count else { return }

            let request = requestListSubject.value[index]
            isLoadingSubject.send(true)

            service.cancelSentRequest(requestId: request.matchingID) { [weak self] result in
                guard let self else { return }

                DispatchQueue.main.async {
                    self.isLoadingSubject.send(false)

                    switch result {
                    case .success:
                        var currentList = self.requestListSubject.value
                        currentList.remove(at: index)
                        self.requestListSubject.send(currentList)
                        self.itemRemovedSubject.send(index)
                        self.requestCancelled.send()

                    case .pathError:
                        self.errorMessageSubject.send("요청 취소에 실패했습니다.")

                    case .networkError:
                        self.errorMessageSubject.send("네트워크 연결을 확인해주세요.")
                    }
                }
            }
        }
    
}

