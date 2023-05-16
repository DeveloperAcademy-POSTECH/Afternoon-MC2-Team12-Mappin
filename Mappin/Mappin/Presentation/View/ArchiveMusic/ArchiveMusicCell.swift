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
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .frame(height: 107)
                .overlay {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(date.dayAndTime)
                            .frame(height: 18)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(Color(red: 0.4235, green: 0.4235, blue: 0.4392))
                            .padding(.leading, 15)
                            .padding(.top, 3)
                            .padding(.bottom, 3)

                        HStack {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(date.yearAndMonth)
                                    .frame(height: 25)
                                    .font(.system(size: 20, weight: .semibold))
                                    .padding(.bottom, 3)
                                
                                Text(music.title)
                                    .frame(height: 20)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(red: 0.2353, green: 0.2353, blue: 0.2627).opacity(0.6))
                                    .lineLimit(1)

                                if !music.artist.isEmpty {
                                    Text(music.artist)
                                        .frame(height: 18)
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(Color(red: 0.2353, green: 0.2353, blue: 0.2627).opacity(0.6))
                                        .lineLimit(1)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.leading, 15)
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
                                .padding(.trailing, 15)
                        }
                        .padding(.bottom, 5)
                    }
                }
        }
    }
}

struct ArchiveMusicCell_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveMusicCell(music: Music(id: "1678057487", title: "Kitsch", artist: "IVE", artwork: URL(string: "https://is3-ssl.mzstatic.com/image/thumb/Music126/v4/99/bb/3a/99bb3a49-4014-db32-5d11-3825a289d9ed/cover_KM0017019_1.jpg/200x200bb.jpg"), appleMusicUrl: nil), date: Date())
    }
}

