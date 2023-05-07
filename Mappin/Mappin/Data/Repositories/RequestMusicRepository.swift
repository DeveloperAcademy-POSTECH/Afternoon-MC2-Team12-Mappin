//
//  RequestSearchMusicRepository.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/04.
//

import Foundation
import MusicKit

final class RequestMusicRepository: RequestMusicRepositoryInterface {

    /// 검색한 음악의 응답을 처리합니다.
    ///  - Parameter searchTerm: music title or artistName
    func requestSearchMusic(
        searchTerm: String
    ) async throws -> [Music] {
        var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Song.self])
        searchRequest.limit = 10
        let searchResponse = try await searchRequest.response()
        let music = searchResponse.songs.map {
            return Music(id: String(describing: $0.id),
                         title: $0.title,
                         artist: $0.artistName,
                         artwork: String(describing: $0.artwork?.url(width: 55, height: 55)),
                         appleMusicUrl: $0.url)
        }
        return music
    }
    
    func requestMusicChart() async throws -> [Music] {
        var chartRequest = MusicCatalogChartsRequest(types: [Song.self])
        chartRequest.limit = 10
        let chartResponse = try await chartRequest.response().songCharts[0].items
        let music = chartResponse.map {
            return Music(id: String(describing: $0.id),
                         title: $0.title,
                         artist: $0.artistName,
                         artwork: String(describing: $0.artwork?.url(width: 55, height: 55)),
                         appleMusicUrl: $0.url)
        }
        return music
    }
    
}
