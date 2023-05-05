//
//  PinClustersListAPITarget.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation

final class PinClustersListAPITarget: APITarget, ParametersRequestable {
    struct Parameters: Encodable {
        let radius: Float
    }
    
    let parameters: Parameters
    
    init(path: String,
         method: Method,
         parameters: Parameters) {
        self.parameters = parameters
        super.init(path: path, method: method)
    }
}
