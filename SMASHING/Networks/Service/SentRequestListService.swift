//
//  SentRequestListService.swift
//  SMASHING
//
//  Created by JIN on 1/17/26.
//

import UIKit

import Moya

//MARK: - NetworkResult

enum NetworkResult<T> {
    case success(T)
    case pathError
    case networkError
}

//MARK: - SentRequestServiceProtocol

protocol SentRequestServiceProtocol {
    func getSentRequestList(completion: @escaping (NetworkResult<SentRequestResultDTO>) -> Void)
    func cancelSentRequest(requestId: String, completion: @escaping (NetworkResult<Bool>) -> Void)
}

//MARK: - SentRequestService

final class SentRequestService: SentRequestServiceProtocol {
    
    let provider = MoyaProvider<SentRequestResultAPI>(plugins: [NetworkLogger()])
    
    func getSentRequestList(completion: @escaping (NetworkResult<SentRequestResultDTO>) -> Void) {
        print("====== [SentRequestService] getSentRequestList 호출 ======")
        provider.request(.getSentRequestResult) { result in
            switch result {
            case .success(let response):
                print("[SentRequestService] 네트워크 성공 - StatusCode: \(response.statusCode)")
                if let jsonString = String(data: response.data, encoding: .utf8) {
                    print("[SentRequestService] Raw Response: \(jsonString)")
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let decoded = try decoder.decode(
                        GenericResponse<SentRequestResultDTO>.self,
                        from: response.data
                    )
                    print("[SentRequestService] 디코딩 성공")
                    completion(.success(decoded.data))
                } catch let decodingError as DecodingError {
                    print("[SentRequestService] 디코딩 실패")
                    switch decodingError {
                    case .keyNotFound(let key, let context):
                        print("  - Key not found: '\(key.stringValue)'")
                        print("  - Context: \(context.debugDescription)")
                        print("  - CodingPath: \(context.codingPath.map { $0.stringValue })")
                    case .typeMismatch(let type, let context):
                        print("  - Type mismatch: expected \(type)")
                        print("  - Context: \(context.debugDescription)")
                        print("  - CodingPath: \(context.codingPath.map { $0.stringValue })")
                    case .valueNotFound(let type, let context):
                        print("  - Value not found: \(type)")
                        print("  - Context: \(context.debugDescription)")
                        print("  - CodingPath: \(context.codingPath.map { $0.stringValue })")
                    case .dataCorrupted(let context):
                        print("  - Data corrupted")
                        print("  - Context: \(context.debugDescription)")
                        print("  - CodingPath: \(context.codingPath.map { $0.stringValue })")
                    @unknown default:
                        print("  - Unknown decoding error: \(decodingError)")
                    }
                    completion(.pathError)
                } catch {
                    print("[SentRequestService] 알 수 없는 에러: \(error)")
                    completion(.pathError)
                }
            case .failure(let error):
                print("[SentRequestService] 네트워크 실패")
                print("  - Error: \(error.localizedDescription)")
                if let response = error.response {
                    print("  - StatusCode: \(response.statusCode)")
                    if let body = String(data: response.data, encoding: .utf8) {
                        print("  - Response Body: \(body)")
                    }
                }
                completion(.networkError)
            }
        }
    }
    
    func cancelSentRequest(requestId: String, completion: @escaping (NetworkResult<Bool>) -> Void) {
        <#code#>
    }
    
    
}
