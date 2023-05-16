//
//  APIPinClustersRepository.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation
import Moya

struct APIPinClustersRepository: PinClustersRepository {
    private let provider = APIProvider()
    
    func readList(
        category: PinsCategory?,
        centerLatitude: Double,
        centerLongitude: Double,
        latitudeDelta: Double,
        longitudeDelta: Double
    ) async throws -> [PinCluster] {
        let parameters = PinClustersListAPITarget.Parameters(
            category: category?.rawValue,
            center_latitude: centerLatitude,
            center_longitude: centerLongitude,
            latitude_delta: latitudeDelta,
            longitude_delta: longitudeDelta
        )
        let target = APITarget.readPinClusters(parameters: parameters)
        let dtos = try await provider.requestResponsable(target)
        return dtos.map { $0.entity }
    }
}
