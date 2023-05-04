//
//  API+Pins.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation

extension API {
    enum Pins: TargetType {
        case create
        case readList
        case readDetail(id: Int)
        case update
        case delete(id: Int)
        
        var path: String {
            switch self {
            case .create, .readList, .update:
                return "/pins"
            case let .readDetail(id), let .delete(id):
                return "/pins/\(id)"
            }
        }
        
        var method: Method {
            switch self {
            case .create:
                return .post
            case .readList, .readDetail:
                return .get
            case .update:
                return .put
            case .delete:
                return .delete
            }
        }
        
        var task: Task {
            .requestPlain
        }
        
        var headers: [String : String]? {
            nil
        }
    }
}
