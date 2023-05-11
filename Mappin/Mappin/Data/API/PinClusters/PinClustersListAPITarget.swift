//
//  PinClustersListAPITarget.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation

final class PinClustersListAPITarget: APITarget, ParametersRequestable, Responsable {
    typealias Parameters = PinsRangeParameters
    typealias Response = [DTO.PinCluster]
    
    let parameters: Parameters
    
    init(path: String,
         method: Method,
         parameters: Parameters) {
        self.parameters = parameters
        super.init(path: path, method: method)
    }
}
