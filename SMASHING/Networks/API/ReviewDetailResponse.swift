//
//  ReviewDetailResponse.swift
//  SMASHING
//
//  Created by 홍준범 on 1/22/26.
//

import Foundation

struct ReviewDetailResponse: Decodable {
    let rating: ReviewScore
    let reviewerNickname: String
    let revieweeNickname: String
    let tag: [ReviewTag]
    let content: String?
}
