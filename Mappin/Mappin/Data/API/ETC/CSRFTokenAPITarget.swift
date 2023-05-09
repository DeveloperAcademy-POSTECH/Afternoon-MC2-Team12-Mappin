//
//  CSRFTokenAPITarget.swift
//  Mappin
//
//  Created by byo on 2023/05/08.
//

import Foundation

final class CSRFTokenAPITarget: APITarget, Responsable {
    typealias Response = String
    
    override var headers: [String : String]? {
        nil
    }
}
