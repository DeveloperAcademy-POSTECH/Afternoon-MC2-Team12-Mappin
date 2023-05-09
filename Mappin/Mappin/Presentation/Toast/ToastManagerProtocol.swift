//
//  ToastManagerProtocol.swift
//  Mappin
//
//  Created by byo on 2023/05/09.
//

import Foundation

protocol ToastManagerProtocol {
    var currentMessage: String? { get }
    func setMessage(_ message: String)
}
