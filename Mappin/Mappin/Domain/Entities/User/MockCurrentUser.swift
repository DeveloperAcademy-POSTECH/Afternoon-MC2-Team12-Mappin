//
//  MockCurrentUser.swift
//  Mappin
//
//  Created by byo on 2023/05/06.
//

import Foundation

final class MockCurrentUser: CurrentUser {
    private let _username = randomHashId
    private let _password = randomHashId
    
    var username: String {
        _username
    }
    
    var password: String {
        _password
    }
    
    var authToken: String?
    
    private static var randomHashId: String {
        String(UUID().uuidString.prefix(8))
    }
}
