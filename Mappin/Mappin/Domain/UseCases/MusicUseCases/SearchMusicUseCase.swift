import Foundation

protocol SearchMusicUseCase {
    func execute(
        searchTerm: String
    ) async throws -> [Music]
}

final class DefaultSearchMusicUseCase: SearchMusicUseCase {
    
    private let musicRepository: RequestMusicRepositoryInterface
    
    init(musicRepository: RequestMusicRepositoryInterface = RequestMusicRepository()) {
        self.musicRepository = musicRepository
    }
    
    func execute(searchTerm: String) async throws -> [Music] {
        return try await musicRepository.requestSearchMusic(searchTerm: searchTerm)
    }
    
}
