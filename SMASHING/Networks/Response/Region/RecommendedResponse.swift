//
//  RecommendedUserResponse.swift
//  SMASHING
//
//  Created by 홍준범 on 1/17/26.
//

import Foundation

struct RecommendedUserResponseDTO: Decodable {
    let recommendUsers: [RecommendedUserDTO]
}

struct RecommendedUserDTO: Decodable {
    let userId: String
    let nickname: String
    let tierId: Int
    let wins: Int
    let losses: Int
    let reviews: Int
    let gender: String
}
