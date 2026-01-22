//
//  SignupRequestDTO.swift
//  SMASHING
//
//  Created by 이승준 on 1/21/26.
//

import Foundation

struct SignupRequestDTO: Encodable {
    let kakaoId: String
    let nickname: String
    let gender: String
    let openChatUrl: String
    let sportCode: String
    let experienceRange: String
    let region: String
}
