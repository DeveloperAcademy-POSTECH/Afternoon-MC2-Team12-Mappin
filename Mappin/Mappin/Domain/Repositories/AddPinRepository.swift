//
//  AddPinRepository.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import Foundation

protocol AddPinRepository {
    
    @discardableResult
    func requestAddPin(
        newPin: Pin
    ) async throws
}
