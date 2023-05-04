//
//  API+Pins.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation
import Moya

extension API {
    enum Pins: TargetType {
        case create(pin: DTO.Pin)
        case readList
        case readDetail(id: Int)
        case update(id: Int, pin: DTO.Pin)
        case delete(id: Int)
        
        var path: String {
            switch self {
            case .create, .readList:
                return "/pins"
            case let .readDetail(id), let .update(id, _), let .delete(id):
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
            switch self {
            case let .create(pin), let .update(_, pin):
                return .requestParameters(parameters: pin.dictionary ?? [:], encoding: JSONEncoding.default)
            default:
                return .requestPlain
            }
        }
    }
}
