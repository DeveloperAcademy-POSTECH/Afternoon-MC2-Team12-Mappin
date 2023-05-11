//
//  Album.swift
//  Mappin
//
//  Created by 예슬 on 2023/05/04.
//

import SwiftUI

// Album Model And Sample Data
struct Album: Identifiable {
    var id = UUID().uuidString
    var albumName: String
    var albumImage: String
    @State var isLiked: Bool = false
}

var albums: [Album] = [
    Album(albumName: "Cowboy In LA", albumImage: "cowboyinla"),
    Album(albumName: "As It Was", albumImage: "asitwas", isLiked: true),
    Album(albumName: "I Don`t Think That I Like Her", albumImage: "idontthinkthat"),
    Album(albumName: "Pocket", albumImage: "pocket"),
    Album(albumName: "Mystery Of Love", albumImage: "callbyname", isLiked: true),
    Album(albumName: "Champagne Supernova", albumImage: "oasis"),
    Album(albumName: "Never Not", albumImage: "lauv"),
    Album(albumName: "True Lover", albumImage: "yerin", isLiked: true),
    Album(albumName: "Up", albumImage: "singstreet")
]
