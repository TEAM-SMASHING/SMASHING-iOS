//
//  ProfileUserService.swift
//  SMASHING
//
//  Created by 이승준 on 1/19/26.
//

import Combine
import Foundation

protocol UserProfileServiceType {
    func fetchMyProfileTier() -> AnyPublisher<MyProfileTierResponse, NetworkError>
    func fetchMyProfiles() -> AnyPublisher<MyProfileListResponse, NetworkError>
    func createProfile(sport: Sports, experience: ExperienceRange) -> AnyPublisher<Void, NetworkError>
    func updateActiveProfile(profileId: String) -> AnyPublisher<Void, NetworkError>
    func fetchOtherUserProfile(userId: String, sport: Sports) -> AnyPublisher<OtherUserProfileResponse, NetworkError>
    func updateRegion(region: String) -> AnyPublisher<Void, NetworkError>
}

final class UserProfileService: UserProfileServiceType {
    func fetchMyProfileTier() -> AnyPublisher<MyProfileTierResponse, NetworkError> {
        return NetworkProvider<ProfileUserTarget>.requestPublisher(.getMyProfileTier, type: MyProfileTierResponse.self)
            .map { response in
                return response.data
            }
            .eraseToAnyPublisher()
    }
    
    func fetchMyProfiles() -> AnyPublisher<MyProfileListResponse, NetworkError> {
        return NetworkProvider<ProfileUserTarget>.requestPublisher(.getMyProfiles, type: MyProfileListResponse.self)
            .map { response in
                return response.data
            }
            .eraseToAnyPublisher()
    }
    
    func createProfile(sport: Sports, experience: ExperienceRange) -> AnyPublisher<Void, NetworkError> {
        let request = CreateProfileRequest(sportCode: sport, experienceRange: experience)
        return NetworkProvider<ProfileUserTarget>.requestPublisher(.createProfile(request: request), type: EmptyDataDTO.self)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    func updateActiveProfile(profileId: String) -> AnyPublisher<Void, NetworkError> {
        let request = UpdateActiveProfileRequest(profileId: profileId)
        return NetworkProvider<ProfileUserTarget>
            .requestPublisher(.updateActiveProfile(request: request), type: EmptyDataDTO.self)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    func fetchOtherUserProfile(userId: String, sport: Sports) -> AnyPublisher<OtherUserProfileResponse, NetworkError> {
        return NetworkProvider<ProfileUserTarget>
            .requestPublisher(.getOtherUserProfile(userId: userId, sportCode: sport), type: OtherUserProfileResponse.self)
            .map { response in
                return response.data
            }
            .eraseToAnyPublisher()
    }
    
    func updateRegion(region: String) -> AnyPublisher<Void, NetworkError> {
        return NetworkProvider<ProfileUserTarget>.requestPublisher(.updateRegion(region: region), type: EmptyDataDTO.self)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
