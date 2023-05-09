//
//  APITarget+ETC.swift
//  Mappin
//
//  Created by byo on 2023/05/08.
//

import Foundation

extension APITarget {
    static let getCSRFToken = CSRFTokenAPITarget(
        path: "/csrf_token",
        method: .get
    )
}
