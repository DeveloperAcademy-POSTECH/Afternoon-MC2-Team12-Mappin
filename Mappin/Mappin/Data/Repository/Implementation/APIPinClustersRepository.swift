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
    
    func readList(centerLatitude: Float, centerLongitude: Float, horizontalRadius: Float, verticalRadius: Float) async throws -> [DTO.PinCluster] {
        let parameters = PinClustersListAPITarget.Parameters(
            center_latitude: centerLatitude,
            center_longitude: centerLongitude,
            horizontal_radius: horizontalRadius,
            vertical_radius: verticalRadius
        )
        let target = APITarget.readPinClusters(parameters: parameters)
        return try await provider.requestResponsable(target)
    }
}
