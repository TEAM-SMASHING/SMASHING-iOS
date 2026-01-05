//
//  AppDIContainer.swift
//  SMASHING
//
//  Created by JIN on 1/6/26.
//

import UIKit

class DIContainer {
    
    //MARK: SingleTon
    
    static let shared = DIContainer()
    private init() {}
    
    //MARK: ClassArray
    private var services: [ObjectIdentifier: Any] = [:]
    
    //MARK: Register
    func register<T>(type: T.Type, component: @escaping () -> T) {
        let key = ObjectIdentifier(type)
        services[key] = component
    }
    
    //MARK: Resolve
    func resolve<T>(type: T.Type) -> T {
        let key = ObjectIdentifier(type)
        let component = services[key] as! () -> T
        return component()
    }
    
}
