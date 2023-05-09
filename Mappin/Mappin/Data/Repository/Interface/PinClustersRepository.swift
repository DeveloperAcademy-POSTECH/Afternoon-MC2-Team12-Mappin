//
//  PinClustersRepository.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation

protocol PinClustersRepository {
    func readList(
        centerLatitude: Float,
        centerLongitude: Float,
        horizontalRadius: Float,
        verticalRadius: Float
    ) async throws -> [DTO.PinCluster]
}
