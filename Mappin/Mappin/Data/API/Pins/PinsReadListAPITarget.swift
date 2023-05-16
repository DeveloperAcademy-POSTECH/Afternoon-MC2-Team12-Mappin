//
//  PinsReadListAPITarget.swift
//  Mappin
//
//  Created by byo on 2023/05/05.
//

import Foundation

final class PinsReadListAPITarget: APITarget, ParametersRequestable, Responsable {
    struct Parameters: Encodable {
        var ids: String
    }
    
    typealias Response = [DTO.Pin]
    
    let parameters: Parameters
    
    init(path: String,
         method: Method,
         parameters: Parameters) {
        self.parameters = parameters
        super.init(path: path, method: method)
    }
}
