//
//  MusicListCell.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/09.
//

import SwiftUI

struct SearchMusicCell: View {
    
    let music: Music
    
    var body: some View {
        HStack {
            if let existingArtwork = music.artwork {
                VStack {
                    Spacer()
                    AsyncImage(url: existingArtwork) { image in
                        image.image?.resizable()
                            .frame(width: 55, height: 55)
                        
                    }
                    Spacer()
                }
            }
            VStack(alignment: .leading) {
                Text(music.title)
                    .font(.system(size: 15, weight: .regular))
                    .lineLimit(1)
                    .foregroundColor(.primary)
                if !music.artist.isEmpty {
                    Text("노래 ・ \(music.artist)")
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                        .padding(.top, -4.0)
                }
            }
            Spacer()
            Button {
                
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.black)
            }

        }
    }
}

//struct MusicListCell_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchMusicCell()
//    }
//}
