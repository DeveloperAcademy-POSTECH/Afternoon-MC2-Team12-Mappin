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
    
    func readList(radius: Float) async throws -> [DTO.PinCluster] {
        let parameters = PinClustersListAPITarget.Parameters(radius: radius)
        let target = APITarget.readPinClusters(parameters: parameters)
        return try await provider.requestResponsable(target)
    }
}
