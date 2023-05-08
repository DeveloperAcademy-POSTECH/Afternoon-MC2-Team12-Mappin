//
//  DeviceManager.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/08.
//

import UIKit

class RequestDeviceRepository: DeviceRepository {
    
    var deviceId: String { UIDevice.current.identifierForVendor!.uuidString }
}
