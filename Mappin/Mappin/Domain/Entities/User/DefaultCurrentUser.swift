//
//  DefaultCurrentUser.swift
//  Mappin
//
//  Created by byo on 2023/05/06.
//

import Foundation

final class DefaultCurrentUser: CurrentUser {
    static let shared = DefaultCurrentUser()
    
    private init() {
    }
    
    var username: String {
        String(deviceId.prefix(8))
    }
    
    var password: String {
        String(deviceId.suffix(8))
    }
    
    var authToken: String?
    var csrfToken: String? = cachedCSRFToken
    
    private var deviceId: String {
        DeviceId.get()!
    }
}
