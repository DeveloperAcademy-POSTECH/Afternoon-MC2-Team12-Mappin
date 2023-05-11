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
        horizontalRadius: Double,
        verticalRadius: Double
    ) async throws -> [Pin] {
        let parameters = PinClustersListAPITarget.Parameters(
            category: category?.rawValue,
            center_latitude: centerLatitude,
            center_longitude: centerLongitude,
            horizontal_radius: horizontalRadius,
            vertical_radius: verticalRadius
        )
        let target = APITarget.readPinClusters(parameters: parameters)
        let dtos = try await provider.requestResponsable(target)
        
        return dtos.map { $0.entity }
    }
}
