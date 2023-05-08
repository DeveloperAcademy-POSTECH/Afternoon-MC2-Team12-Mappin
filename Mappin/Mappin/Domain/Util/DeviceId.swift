//
//  DeviceId.swift
//  Mappin
//
//  Created by byo on 2023/05/06.
//

import UIKit
import Security

struct DeviceId {
    private static let service = "mappin"
    private static let account = "device"
    
    static func get() -> String? {
        // keychain에서 deviceId 값을 읽어옴
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        // keychain에 값이 있으면 그 값을 반환
        if status == errSecSuccess {
            if let data = result as? Data,
                let deviceId = String(data: data, encoding: .utf8) {
                return deviceId
            }
        }

        // keychain에 값이 없으면 새로 생성해서 저장
        if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
            query = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: account,
                kSecValueData as String: deviceId.data(using: .utf8)!
            ]
            SecItemAdd(query as CFDictionary, nil)
            return deviceId
        }

        return nil
    }
}
