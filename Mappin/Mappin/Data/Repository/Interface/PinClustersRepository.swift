//
//  PinClustersRepository.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation

protocol PinClustersRepository {
    func readList(
        category: PinsCategory?,
        centerLatitude: Double,
        centerLongitude: Double,
        latitudeDelta: Double,
        longitudeDelta: Double
    ) async throws -> [Pin]
}
