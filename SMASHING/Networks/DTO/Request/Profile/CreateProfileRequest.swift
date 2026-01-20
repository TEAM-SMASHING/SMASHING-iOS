//
//  CreateProfileRequest.swift
//  SMASHING
//
//  Created by 이승준 on 1/19/26.
//

import Foundation

struct CreateProfileRequest: Encodable {
    let sportCode: Sports
    let experienceRange: ExperienceRange
}
