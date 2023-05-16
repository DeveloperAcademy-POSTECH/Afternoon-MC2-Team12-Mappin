//
//  PinClustersListAPITarget.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation

final class PinClustersListAPITarget: APITarget, ParametersRequestable, Responsable {
    struct Parameters: Encodable {
        let category: String?
        let center_latitude: Double
        let center_longitude: Double
        let latitude_delta: Double
        let longitude_delta: Double
    }
    
    typealias Response = [DTO.PinCluster]
    
    let parameters: Parameters
    
    init(path: String,
         method: Method,
         parameters: Parameters) {
        self.parameters = parameters
        super.init(path: path, method: method)
    }
}
