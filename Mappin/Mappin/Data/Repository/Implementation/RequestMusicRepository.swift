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
    ///  return: Music Entities(List)
    func requestSearchMusic(
        searchTerm: String
    ) async throws -> [Music] {
        var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Song.self])
        searchRequest.limit = 10
        let searchResponse = try await searchRequest.response()
        return searchResponse.songs.songToMusic()
    }
    
    /// 음악을 검색하지 않았을 경우, 보여줄 차트(~10위)를 호출합니다.
    /// return: Music Entities(List)
    func requestMusicChart() async throws -> [Music] {
        var chartRequest = MusicCatalogChartsRequest(types: [Song.self])
        chartRequest.limit = 10
        let chartResponse = try await chartRequest.response().songCharts[0].items
        return chartResponse.songToMusic()
    }
    
}

/// 유저가 애플 뮤직에서 음악을 재생할 수 있도록 이동합니다.
/// return: void
//    func openAppleMusic(url: URL?) {
//        guard let appleMusicUrl = url,
//              UIApplication.shared.canOpenURL(appleMusicUrl)
//        else {
//            print("URL이 없는 음악이거나, URL을 열 수 없음.")
//            return
//        }
//        UIApplication.shared.open(appleMusicUrl)
//    }
