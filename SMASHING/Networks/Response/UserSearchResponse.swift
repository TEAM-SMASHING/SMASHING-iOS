//
//  UserSearchResponse.swift
//  SMASHING
//
//  Created by 이승준 on 1/19/26.
//

import Foundation

struct UserSearchResponse: Decodable {
    let users: [UserSummary]
}

struct UserSummary: Decodable {
    let userId: String
    let nickname: String
}
