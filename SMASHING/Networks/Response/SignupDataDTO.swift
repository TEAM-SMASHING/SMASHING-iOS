//
//  SignupDataDTO.swift
//  SMASHING
//
//  Created by 이승준 on 1/21/26.
//

import Foundation

struct SignupDataDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let userId: String
}
