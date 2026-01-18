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
}
