//
//  GenericResponse.swift
//  SMASHING
//
//  Created by 이승준 on 1/5/26.
//

import Foundation

struct GenericResponse<T: Decodable>: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T
}
