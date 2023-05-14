//
//  PinsLatestAPITarget.swift
//  Mappin
//
//  Created by byo on 2023/05/15.
//

import Foundation

final class PinsLatestAPITarget: APITarget, ParametersRequestable, Responsable {
    struct Parameters: Encodable {
        let category: String?
    }
    
    typealias Response = DTO.Pin
    
    let parameters: Parameters
    
    init(path: String,
         method: Method,
         parameters: Parameters) {
        self.parameters = parameters
        super.init(path: path, method: method)
    }
}
