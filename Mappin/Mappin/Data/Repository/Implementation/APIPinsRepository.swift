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
    private let decoder = APIJSONDecoder()
    
    func create(pin: DTO.Pin) async throws {
        _ = try await provider.request(.createPin(parameters: pin)).get()
    }
    
    func readList() async throws -> [DTO.Pin] {
        let data = try await provider.request(.readPins).get().data
        return try decoder.decode([DTO.Pin].self, from: data)
    }
    
    func readDetail(id: Int) async throws -> DTO.Pin {
        let data = try await provider.request(.readPin(id: id)).get().data
        return try decoder.decode(DTO.Pin.self, from: data)
    }
    
    func update(pin: DTO.Pin) async throws {
        _ = try await provider.request(.updatePin(parameters: pin)).get()
    }
    
    func delete(id: Int) async throws {
        _ = try await provider.request(.deletePin(id: id)).get()
    }
}
