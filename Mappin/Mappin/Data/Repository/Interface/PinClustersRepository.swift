//
//  PinClustersRepository.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation

protocol PinClustersRepository {
    func readList(
        centerLatitude: Double,
        centerLongitude: Double,
        horizontalRadius: Double,
        verticalRadius: Double
    ) async throws -> [DTO.PinCluster]
}
