//
//  APIPinClustersRepository.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation
import Moya

struct APIPinClustersRepository: PinClustersRepository {
    private let provider = MoyaProvider<API.PinClustersReadList>()
    private let decoder = APIJSONDecoder()
    
    func readList(radius: Float) async throws -> [DTO.PinCluster] {
        let parameters = API.PinClustersReadList.Parameters(radius: radius)
        let data = try await provider.request(.init(parameters: parameters)).get().data
        return try decoder.decode([DTO.PinCluster].self, from: data)
    }
}
