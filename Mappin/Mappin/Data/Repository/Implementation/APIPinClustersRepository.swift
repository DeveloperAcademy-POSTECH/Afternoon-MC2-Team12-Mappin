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
    private let decoder = APIJSONDecoder()
    
    func readList(radius: Float) async throws -> [DTO.PinCluster] {
        let parameters = PinClustersListAPITarget.Parameters(radius: radius)
        let data = try await provider.request(.readPinClusters(parameters: parameters)).get().data
        return try decoder.decode([DTO.PinCluster].self, from: data)
    }
}
