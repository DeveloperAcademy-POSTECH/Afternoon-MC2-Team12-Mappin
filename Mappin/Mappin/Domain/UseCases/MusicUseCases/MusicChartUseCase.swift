//
//  MusicChartUseCase.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/04.
//

import Foundation

protocol MusicChartUseCase {
    func execute() async throws -> [Music]
}

final class DefaultMusicChartUseCase: MusicChartUseCase {
    
    private let musicRepository: RequestMusicRepositoryInterface
    
    init(musicRepository: RequestMusicRepositoryInterface) {
        self.musicRepository = musicRepository
    }
    
    func execute() async throws -> [Music] {
        return try await musicRepository.requestMusicChart()
    }
    
}
