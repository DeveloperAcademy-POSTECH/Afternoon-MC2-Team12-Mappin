//
//  RequestSearchMusicRepository.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/04.
//

import Foundation
import MusicKit

final class RequestSearchMusicRepository: RequestSearchMusicRepositoryInterface {
    
    func requestSearchMusic(searchTerm: String) async throws -> [Music] {
        var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Song.self])
        searchRequest.limit = 10
        do {
            let searchResponse = try await searchRequest.response()
            var music: [Music] = []
            for i in 0..<searchResponse.songs.count {
                music.append(Music(id: searchResponse.songs[i].id, title: searchResponse.songs[i].title, artist: searchResponse.songs[i].artistName, artwork: searchResponse.songs[i].artwork, appleMusicUrl: searchResponse.songs[i]))
            }
            return [Music(id: "1",
                          title: "1",
                          artist: "1",
                          artwork: "1",
                          appleMusicUrl: URL(string: "www.naver.com")!)]
        } catch {
            print("Error")
            return []
        }
    }
    
    
}
