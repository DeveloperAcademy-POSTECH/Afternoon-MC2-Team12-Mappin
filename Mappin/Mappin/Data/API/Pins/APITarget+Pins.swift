//
//  APITarget+Pins.swift
//  Mappin
//
//  Created by byo on 2023/05/05.
//

import Foundation

extension APITarget {
    private static let basePath = "/pins"
    
    static func createPin(parameters: PinsCreateAPITarget.Parameters) -> APITarget {
        PinsCreateAPITarget(
            path: basePath,
            method: .post,
            parameters: parameters
        )
    }
    
    static let readPins = PinsReadListAPITarget(
        path: basePath,
        method: .get
    )
    
    static func readPin(id: Int) -> APITarget {
        PinsReadDetailAPITarget(
            path: basePath + "/\(id)",
            method: .delete
        )
    }
    
    static func updatePin(parameters: PinsUpdateAPITarget.Parameters) -> APITarget {
        PinsUpdateAPITarget(
            path: basePath + "/\(parameters.id)",
            method: .put,
            parameters: parameters
        )
    }
    
    static func deletePin(id: Int) -> APITarget {
        PinsDeleteAPITarget(
            path: basePath + "/\(id)",
            method: .delete
        )
    }
}
