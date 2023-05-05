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
}
