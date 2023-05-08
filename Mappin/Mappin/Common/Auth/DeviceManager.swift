//
//  DeviceManager.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/08.
//

import UIKit

protocol DeviceRepository {
    var deviceId: String { get }
}

class DeviceManager: DeviceRepository {
    var deviceId: String { UIDevice.current.identifierForVendor!.uuidString }
}
