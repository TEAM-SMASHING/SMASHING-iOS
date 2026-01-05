//
//  AppDIContainer.swift
//  SMASHING
//
//  Created by JIN on 1/6/26.
//

import UIKit

enum DIScope {

    case SingleTon
    case Tranient
}

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
        guard let component = services[key] as? () -> T else { return <#default value#> }
        return component()
    }
    
}
