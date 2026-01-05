//
//  NetworkLogger.swift
//  Smashing-Assignment
//
//  Created by 이승준 on 12/30/25.
//

import Foundation

import Moya

final class NetworkLogger: PluginType {
    
    // MARK: - API Calls
    
    func willSend(_ request: RequestType, target: TargetType) {
        guard let req = request.request else {
            print("❌ [REQUEST] Invalid request")
            return
        }
        
        print("\n====== 📤 Request ======")
        print("➡️ URL: \(req.url?.absoluteString ?? "nil")")
        print("➡️ METHOD: \(req.httpMethod ?? "nil")")
        
        if let headers = req.allHTTPHeaderFields, !headers.isEmpty {
            print("➡️ HEADERS:")
            headers.forEach { key, value in
                print("   \(key): \(value)")
            }
        }
        
        if let body = req.httpBody,
           let pretty = prettyJSONString(from: body) {
            print("➡️ BODY:\n\(pretty)")
        }
        
        print("========================\n")
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        print("\n====== 📥 Response ======")
        
        switch result {
        case .success(let response):
            print("⬅️ STATUS: \(response.statusCode)")
            print("⬅️ URL: \(response.request?.url?.absoluteString ?? "nil")")
            
            if let pretty = prettyJSONString(from: response.data) {
                print("⬅️ BODY:\n\(pretty)")
            } else {
                print("⬅️ BODY: (empty or non-readable)")
            }
            
        case .failure(let error):
            print("❌ ERROR:", error.localizedDescription)
            
            if let data = error.response?.data,
               let pretty = prettyJSONString(from: data) {
                print("❌ ERROR BODY:\n\(pretty)")
            }
        }
        
        print("========================\n")
    }
    
    // MARK: - Private Methods
    private func prettyJSONString(from data: Data) -> String? {
        guard
            let object = try? JSONSerialization.jsonObject(with: data),
            let prettyData = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyString = String(data: prettyData, encoding: .utf8)
        else { return nil }
        
        return prettyString
    }
}

