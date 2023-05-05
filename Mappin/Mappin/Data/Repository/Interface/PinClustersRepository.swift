//
//  PinClustersRepository.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation

protocol PinClustersRepository {
    func readList(radius: Float) async throws -> [DTO.PinCluster]
}
