//
//  GenericResponse.swift
//  SMASHING
//
//  Created by 이승준 on 1/5/26.
//

import Foundation

struct GenericResponse<T: Decodable>: Decodable {
    let status: String
    let statusCode: Int
    let data: T
    let timestamp: String
}
