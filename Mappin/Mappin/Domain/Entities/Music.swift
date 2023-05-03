//
//  Music.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/03.
//

import Foundation

struct Music: Equatable, Identifiable {
    let id: String
    let title: String
    let artist: String
    let artwork: String?
    let appleMusicUrl: URL
}

