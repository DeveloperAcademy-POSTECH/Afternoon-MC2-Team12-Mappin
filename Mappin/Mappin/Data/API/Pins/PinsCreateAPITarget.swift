//
//  PinsCreateAPITarget.swift
//  Mappin
//
//  Created by byo on 2023/05/05.
//

import Foundation

final class PinsCreateAPITarget: APITarget, ParametersRequestable {
    struct Parameters: Encodable {
        let applemusic_id: String
        let title: String
        let artist_name: String
        let latitude: Float
        let longitude: Float
        let administrative_area: String
        let locality: String
        let weather: String
        let temperture: Int
    }
    
    let parameters: Parameters
    
    init(path: String,
         method: Method,
         parameters: Parameters) {
        self.parameters = parameters
        super.init(path: path, method: method)
    }
}
