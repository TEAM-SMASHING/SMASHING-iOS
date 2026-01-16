//
//  InputOutputProtocol.swift
//  SMASHING
//
//  Created by 이승준 on 1/16/26.
//

import Combine

protocol InputOutputProtocol: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(input: AnyPublisher<Input, Never>) -> Output
}
