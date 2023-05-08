//
//  APIPinsRepository.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation
import Moya

struct APIPinsRepository: PinsRepository {
    private let provider = APIProvider()
    
    func create(pin: DTO.Pin) async throws {
        try await provider.justRequest(.createPin(parameters: pin))
    }
    
    func readList() async throws -> [DTO.Pin] {
        try await provider.requestResponsable(APITarget.readPins)
    }
    
    func readDetail(id: Int) async throws -> DTO.Pin {
        try await provider.requestResponsable(APITarget.readPin(id: id))
    }
    
    func update(pin: DTO.Pin) async throws {
        try await provider.justRequest(.updatePin(parameters: pin))
    }
    
    func delete(id: Int) async throws {
        try await provider.justRequest(.deletePin(id: id))
    }
}
