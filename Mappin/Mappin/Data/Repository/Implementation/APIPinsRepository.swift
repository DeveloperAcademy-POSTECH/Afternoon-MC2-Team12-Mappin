//
//  APIPinsRepository.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation
import Moya

struct APIPinsRepository: PinsRepository {
    private let provider = MoyaProvider<API.Pins>()
    private let decoder = APIJSONDecoder()
    
    func create(pin: DTO.Pin) async throws {
        _ = try await provider.request(.create(pin: pin)).get()
    }
    
    func readList() async throws -> [DTO.Pin] {
        let data = try await provider.request(.readList).get().data
        return try decoder.decode([DTO.Pin].self, from: data)
    }
    
    func readDetail(id: Int) async throws -> DTO.Pin {
        let data = try await provider.request(.readDetail(id: id)).get().data
        return try decoder.decode(DTO.Pin.self, from: data)
    }
    
    func update(pin: DTO.Pin) async throws {
        _ = try await provider.request(.update(id: pin.id, pin: pin)).get()
    }
    
    func delete(id: Int) async throws {
        _ = try await provider.request(.delete(id: id)).get()
    }
}
