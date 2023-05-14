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
        VStack {
            HStack {
                Text(date.listFormat)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(red: 0.4235, green: 0.4235, blue: 0.4392))
                Spacer()
            }
            
            HStack(spacing: 0) {
                Text("")
                    .frame(width: 0, height: 0)
                Rectangle()
                    .frame(width: 55, height: 55)
                    .foregroundColor(Color(uiColor: .systemGray4))
                    .overlay {
                        if let existingArtwork = music.artwork {
                            AsyncImage(url: existingArtwork) { image in
                                image
                                    .resizable()
                                    .frame(width: 55, height: 55)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 55, height: 55)
                            }
                        }
                    }
                    .cornerRadius(8)
                    .padding(.trailing, 10)

                VStack(alignment: .leading) {
                    Text(music.title)
                        .lineLimit(1)
                        .foregroundColor(.primary)
                        .padding(.bottom, -5)
                    if !music.artist.isEmpty {
                        Text("노래 ・ \(music.artist)")
                            .lineLimit(1)
                            .foregroundColor(.secondary)
                    }
                }
                .font(.system(size: 15, weight: .regular))
                
                Spacer()
            }
        }

    }
}

