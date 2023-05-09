//
//  APITarget+Pins.swift
//  Mappin
//
//  Created by byo on 2023/05/05.
//

import Foundation

extension APITarget {
    private static let basePath = "/pins"
    
    static func createPin(parameters: PinsCreateAPITarget.Parameters) -> PinsCreateAPITarget {
        .init(
            path: basePath + "/",
            method: .post,
            parameters: parameters
        )
    }
    
    static func readPins(parameters: PinsReadListAPITarget.Parameters) -> PinsReadListAPITarget {
        .init(
            path: basePath,
            method: .get,
            parameters: parameters
        )
    }
    
    static func readPin(id: Int) -> PinsReadDetailAPITarget {
        .init(
            path: basePath + "/\(id)",
            method: .delete
        )
    }
    
    static func updatePin(parameters: PinsUpdateAPITarget.Parameters) -> PinsUpdateAPITarget {
        .init(
            path: basePath + "/\(parameters.id)",
            method: .put,
            parameters: parameters
        )
    }
    
    static func deletePin(id: Int) -> PinsDeleteAPITarget {
        .init(
            path: basePath + "/\(id)",
            method: .delete
        )
    }
}
