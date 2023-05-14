//
//  RemovePinUseCase.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/14.
//

import Foundation

protocol RemovePinUseCase {
    func execute(id: Int) async throws
}

final class DefaultRemovePinUseCase: RemovePinUseCase {
    
    private let pinsRepository: PinsRepository
    
    init(pinsRepository: PinsRepository) {
        self.pinsRepository = pinsRepository
    }
    
    func execute(id: Int) async throws {
        try await pinsRepository.delete(id: id)
    }
    
}
