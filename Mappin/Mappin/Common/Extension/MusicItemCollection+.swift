//
//  Collection+.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/08.
//

import Foundation

import MusicKit

extension MusicItemCollection where Element == Song {
    func songToMusic() -> [Music] {
        return self.map {
            return Music(id: String(describing: $0.id),
                         title: $0.title,
                         artist: $0.artistName,
                         artwork: $0.artwork?.url(width: 99, height: 99),
                         appleMusicUrl: $0.url)
        }
    }
}
