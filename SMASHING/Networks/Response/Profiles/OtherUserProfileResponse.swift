//
//  OtherUserProfileResponse.swift
//  SMASHING
//
//  Created by 이승준 on 1/19/26.
//

import Foundation

struct OtherUserProfileResponse: Decodable {
    let nickname: String
    let gender: Gender
    let selectedProfile: ActiveProfile
    let allProfiles: [SimpleProfile]
    let isChallengeable: Bool

    private enum CodingKeys: String, CodingKey {
        case nickname
        case gender
        case selectedProfile
        case allProfiles
        case isChallengeable
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.gender = try container.decode(Gender.self, forKey: .gender)
        self.selectedProfile = try container.decode(ActiveProfile.self, forKey: .selectedProfile)
        self.allProfiles = try container.decode([SimpleProfile].self, forKey: .allProfiles)
        self.isChallengeable = try container.decodeIfPresent(Bool.self, forKey: .isChallengeable) ?? true
    }
}
