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
    
    let musicRepository: MusicRepository
    
    init(musicRepository: MusicRepository) {
        self.musicRepository = musicRepository
    }
    
    func execute(searchTerm: String) async throws -> Music {
        return try await musicRepository.requsetSearchMusic(searchTerm: searchTerm)
    }
    
}
