//
//  CurrentUser.swift
//  Mappin
//
//  Created by byo on 2023/05/06.
//

import Foundation

protocol CurrentUser: AnyObject {
    var username: String { get }
    var password: String { get }
    var authToken: String? { get set }
    var csrfToken: String? { get set }
}

extension CurrentUser {
    static var cachedCSRFToken: String? {
        HTTPCookieStorage.shared.cookies?.first(where: { $0.name == "csrftoken" })?.value
    }
}
