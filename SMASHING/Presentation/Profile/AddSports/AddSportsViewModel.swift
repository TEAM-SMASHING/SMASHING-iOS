//
//  AddSportsViewModel.swift
//  SMASHING
//
//  Created by JIN on 1/22/26.
//

import Combine
import Foundation

protocol AddSportsViewModelProtocol: InputOutputProtocol
where Input == AddSportsViewModel.Input, Output == AddSportsViewModel.Output {
    var selectedSport: Sports? { get }
    var selectedExperience: ExperienceRange? { get }
}

final class AddSportsViewModel: AddSportsViewModelProtocol {
    
    enum Input {
        case sportSelected(Sports)
        case experienceSelected(ExperienceRange)
        case submit
    }
    
    struct Output {
        let isLoading = PassthroughSubject<Bool, Never>()
        let submitCompleted = PassthroughSubject<Void, Never>()
        let errorMessage = PassthroughSubject<String, Never>()
    }
    
    let output = Output()
    private let service: UserProfileServiceType
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var selectedSport: Sports?
    private(set) var selectedExperience: ExperienceRange?
    
    init(service: UserProfileServiceType = UserProfileService()) {
        self.service = service
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> Output {
        input
            .sink { [weak self] input in
                guard let self else { return }
                switch input {
                case .sportSelected(let sport):
                    self.selectedSport = sport
                case .experienceSelected(let experience):
                    self.selectedExperience = experience
                case .submit:
                    self.submit()
                }
            }
            .store(in: &cancellables)
        
        return output
    }
    
    private func submit() {
        guard let selectedSport, let selectedExperience else {
            output.errorMessage.send("종목과 구력을 선택해주세요.")
            return
        }
        
        output.isLoading.send(true)
        service.createProfile(sport: selectedSport, experience: selectedExperience)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.output.isLoading.send(false)
                if case .failure(let error) = completion {
                    self.output.errorMessage.send(error.localizedDescription)
                }
            } receiveValue: { [weak self] in
                self?.output.submitCompleted.send()
            }
            .store(in: &cancellables)
    }
}
