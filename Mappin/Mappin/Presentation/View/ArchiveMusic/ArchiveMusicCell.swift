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
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(date.dayAndTime)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Color(red: 0.4235, green: 0.4235, blue: 0.4392))
                Spacer()
            }
//            .padding(.bottom, -5)
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text(date.yearAndMonth)
                        .font(.system(size: 20, weight: .semibold))
                    
                    Text(music.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(red: 0.2353, green: 0.2353, blue: 0.2627).opacity(0.6))
                        .lineLimit(1)
                        .padding(.bottom, 2)
                        
//                        .padding(.bottom, -5)
                    if !music.artist.isEmpty {
                        Text("노래 ・ \(music.artist)")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(Color(red: 0.2353, green: 0.2353, blue: 0.2627).opacity(0.6))
                            .lineLimit(1)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                Rectangle()
                    .frame(width: 64, height: 64)
                    .foregroundColor(Color(uiColor: .systemGray4))
                    .overlay {
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
                    .cornerRadius(8)
                    .padding(.trailing, 10)
            }
//            .padding(.top, -5)
        }
    }
}

struct ArchiveMusicCell_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveMusicCell(music: Music(id: "1678057487", title: "Kitsch", artist: "IVE", artwork: URL(string: "https://is3-ssl.mzstatic.com/image/thumb/Music126/v4/99/bb/3a/99bb3a49-4014-db32-5d11-3825a289d9ed/cover_KM0017019_1.jpg/200x200bb.jpg"), appleMusicUrl: nil), date: Date())
    }
}

