//
//  BaseTarget.swift
//  Smashing-Assignment
//
//  Created by 이승준 on 12/30/25.
//

import Foundation

import Moya

protocol BaseTargetType: TargetType { }

extension BaseTargetType{

    var baseURL: URL {
        return URL(string:Environment.baseURL)!
    }

    var headers: [String : String]? {
        let header = [
            "Content-Type": "application/json"
        ]
        return header
    }

    var sampleData: Data {
        return Data()
    }
}
