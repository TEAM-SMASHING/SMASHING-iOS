//
//  NetworkProvider.swift
//  Smashing-Assignment
//
//  Created by 이승준 on 12/30/25.
//

import Combine
import Foundation

import CombineMoya
import Moya

final class NetworkProvider<API: TargetType> {
    static func requestPublisher<T: Decodable>(
        _ target: API,
        type: T.Type
    ) -> AnyPublisher<GenericResponse<T>, NetworkError> {
        let provider = MoyaProvider<API>(plugins: [NetworkLogger()])
        
        return Future<GenericResponse<T>, NetworkError> { promise in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    switch response.statusCode {
                    case 200...299:
                        do {
                            let decodedResponse = try JSONDecoder().decode(GenericResponse<T>.self, from: response.data)
                            promise(.success(decodedResponse))
                        } catch {
                            print("Decoding Error: \(error)")
                            promise(.failure(.decoding))
                        }
                    case 401: promise(.failure(.unauthorized))
                    case 403: promise(.failure(.forbidden))
                    case 404: promise(.failure(.notFound))
                    case 500...599:
                        let msg = String(data: response.data, encoding: .utf8) ?? "Server Error"
                        promise(.failure(.serverError(msg)))
                    default:
                        promise(.failure(.unknown))
                    }
                case .failure:
                    promise(.failure(.networkFail))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    static func kakaoAddressRequestPublisher<T: Decodable>(
        _ target: API,
        type: T.Type
    ) -> AnyPublisher<T, NetworkError> {
        let provider = MoyaProvider<API>(plugins: [NetworkLogger()])
        
        return Future<T, NetworkError> { promise in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    if (200...299).contains(response.statusCode) {
                        do {
                            let decodedResponse = try JSONDecoder().decode(T.self, from: response.data)
                            promise(.success(decodedResponse))
                        } catch {
                            promise(.failure(.decoding))
                        }
                    } else {
                        
                    }
                case .failure:
                    promise(.failure(.networkFail))
                }
            }
        }.eraseToAnyPublisher()
    }
}
