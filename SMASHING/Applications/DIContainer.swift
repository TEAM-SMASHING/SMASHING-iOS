//
//  DIContainer.swift
//  SMASHING
//
//  Created by JIN on 1/6/26.
//

import UIKit

enum DIScope {
    case singleton
    case transient
}

final class DIContainer {

    // MARK: - Singleton

    static let shared = DIContainer()
    init() {}

    // MARK: - Storage

    private var factories: [ObjectIdentifier: (DIContainer) -> Any] = [:]
    private var scopes: [ObjectIdentifier: DIScope] = [:]
    private var singletonInstances: [ObjectIdentifier: Any] = [:]

    // MARK: - Register

    func register<T>(type: T.Type, scope: DIScope = .singleton, component: @escaping (DIContainer) -> T) {
        let key = ObjectIdentifier(type)
        self.factories[key] = component
        self.scopes[key] = scope
    }

    // MARK: - Resolve

    func resolve<T>(type: T.Type) -> T {
        let key = ObjectIdentifier(type)
        let factory = self.factories[key] as! (DIContainer) -> T
        let scope = self.scopes[key]!

        switch scope {
        case .singleton:
            if let instance = self.singletonInstances[key] as? T {
                return instance
            }
            let newInstance = factory(self)
            self.singletonInstances[key] = newInstance
            return newInstance

        case .transient:
            return factory(self)
        }
    }

}

// MARK: - Dependency Registration

extension DIContainer {
    
    func registerAllDependencies() {
        registerServices()
        registerViewModels()
    }
    
    // MARK: - Services (Singleton)
    
    private func registerServices() {
        
    }
    
    // MARK: - ViewModels (Transient)
    
    private func registerViewModels() {
        
    }
    
}
