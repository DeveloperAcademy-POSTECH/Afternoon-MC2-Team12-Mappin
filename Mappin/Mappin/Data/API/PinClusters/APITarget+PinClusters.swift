//
//  APITarget+PinClusters.swift
//  Mappin
//
//  Created by byo on 2023/05/05.
//

import Foundation

extension APITarget {
    private static let basePath = "/pin_clusters"
    
    static func readPinClusters(parameters: PinClustersListAPITarget.Parameters) -> PinClustersListAPITarget {
        .init(
            path: basePath,
            method: .get,
            parameters: parameters
        )
    }
}
