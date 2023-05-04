//
//  MusicRepository.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/03.
//

import Foundation

protocol RequestMusicRepositoryInterface {
    func requestSearchMusic(
        searchTerm: String
    ) async throws -> [Music]
    
    func requestMusicChart() async throws -> [Music]
}
