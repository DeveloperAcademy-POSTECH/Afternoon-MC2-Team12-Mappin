//
//  MappinDIContainer.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/09.
//

import Foundation

final class MappinDIContainer {
    
    struct Dependencies {
        var currentUser: CurrentUser
    }
    
   // private let dependencies: Dependencies
    var resolver = Resolver()
    
    
//    init(dependencies: Dependencies) {
//        self.dependencies = dependencies
//    }
//    
    struct Resolver {
        
        var DIDictionary = TypeDictionary<Any>()
        
        func resolve<T>(_ type: T.Type) -> T {
            return DIDictionary[type.self] as! T
        }
        
    }
    
    func register<T>(_ type: T.Type, _ completion: @escaping (Resolver) -> T) {
        let result = completion(self.resolver)
        
        resolver.DIDictionary[type.self] = result
    }
    
    struct TypeDictionary<Value> {
        private var storage: [ObjectIdentifier: (Value)] = [:]
        
        subscript<T>(key: T.Type) -> Value? {
            get {
                return storage[ObjectIdentifier(key)]
            }
            set {
                storage[ObjectIdentifier(key)] = newValue
            }
        }
    }
}
