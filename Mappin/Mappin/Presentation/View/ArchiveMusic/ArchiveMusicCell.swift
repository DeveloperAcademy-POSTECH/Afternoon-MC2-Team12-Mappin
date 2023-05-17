//
//  ArchiveMusicCell.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/11.
//

import SwiftUI

struct ArchiveMusicCell: View {
    var music: Music
    var date: Date
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(date.yearAndMonth)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(red: 108 / 255, green: 108 / 255, blue: 112 / 255))
                    .padding(.bottom, 10)
                Text(music.title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                Text(music.artist)
                    .font(.system(size: 17))
                    .foregroundColor(Color(red: 60 / 255, green: 60 / 255, blue: 67 / 255, opacity: 0.6))
            }
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            Spacer()
            Group {
                if let existingArtwork = music.artwork {
                    AsyncImage(url: existingArtwork) { image in
                        image
                            .resizable()
                            .frame(width: 64, height: 64)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 64, height: 64)
                    }
                }
            }
            .background(Color.black.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .frame(height: 95)
        .padding(.leading, 20)
        .padding(.trailing, 16)
        .background(Color.white.cornerRadius(6))
    }
}

struct ArchiveMusicCell_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveMusicCell(music: Music(id: "1678057487", title: "Kitsch", artist: "IVE", artwork: URL(string: "https://is3-ssl.mzstatic.com/image/thumb/Music126/v4/99/bb/3a/99bb3a49-4014-db32-5d11-3825a289d9ed/cover_KM0017019_1.jpg/200x200bb.jpg"), appleMusicUrl: nil), date: Date())
    }
}

