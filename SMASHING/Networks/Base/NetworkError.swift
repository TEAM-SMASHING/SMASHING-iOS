//
//  NetworkError.swift
//  Smashing-Assignment
//
//  Created by 이승준 on 12/30/25.
//

import Foundation

public enum NetworkError: Error {
    case decoding
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case serverError(String)
    case networkFail
    case unknown
}
