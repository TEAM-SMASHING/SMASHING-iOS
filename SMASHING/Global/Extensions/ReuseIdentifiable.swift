//
//  ReuseIdentifiable.swift
//  SMASHING
//
//  Created by 이승준 on 1/5/26.
//

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}
