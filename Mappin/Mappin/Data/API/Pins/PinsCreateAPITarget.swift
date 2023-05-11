//
//  PinsCreateAPITarget.swift
//  Mappin
//
//  Created by byo on 2023/05/05.
//

import Foundation

final class PinsCreateAPITarget: APITarget, ParametersRequestable {
    struct Parameters: Encodable {
        struct Music: Encodable {
            let applemusic_id: String
            let title: String
            let artist_name: String
        }
        let music: Music
        let latitude: Double
        let longitude: Double
        let locality: String
        let sub_locality: String
        let weather: String
        let temperature: Int
    }
    
    let parameters: Parameters
    
    init(path: String,
         method: Method,
         parameters: Parameters) {
        self.parameters = parameters
        super.init(path: path, method: method)
    }
}
