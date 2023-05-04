//
//  API+PinClusters.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation
import Moya

extension API {
    struct PinClustersReadList: TargetType {
        struct Parameters: Codable {
            let radius: Float
        }
        
        let parameters: Parameters
        
        var path: String {
            "/pin_clusters"
        }
        
        var method: Method {
            .get
        }
        
        var task: Task {
            .requestParameters(parameters: parameters.dictionary ?? [:], encoding: URLEncoding.queryString)
        }
        
        var headers: [String : String]? {
            nil
        }
    }
}
