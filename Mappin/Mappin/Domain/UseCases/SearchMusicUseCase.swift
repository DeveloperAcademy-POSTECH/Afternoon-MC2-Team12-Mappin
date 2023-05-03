//
//  MusicUseCase.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/03.
//

import Foundation

protocol SearchMusicUseCase {
    func execute(searchTerm: String) async throws -> Music
}

final class DefaultSearchMusicUseCase: SearchMusicUseCase {
    
    private let musicRepository: RequestSearchMusicRepository
    
    init(musicRepository: RequestSearchMusicRepository) {
        self.musicRepository = musicRepository
    }
    
    func execute(searchTerm: String) async throws -> Music {
        return try await musicRepository.requestSearchMusic(searchTerm: searchTerm)
    }
    
}
