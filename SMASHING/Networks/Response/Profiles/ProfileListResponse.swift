//
//  ProfileListResponse.swift
//  SMASHING
//
//  Created by 이승준 on 1/19/26.
//

import Foundation

struct ProfileListResponse: Decodable {
    let nickname: String
    let gender: Gender
    let activeProfile: ActiveProfile
    let allProfiles: [SimpleProfile]
}
