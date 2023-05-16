//
//  ArchiveInfoView.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/16.
//

import SwiftUI

struct ArchiveInfoView: View {
    // 357
    
    var pin: Pin
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        HStack(spacing: 5) {
                            Image(systemName: pin.weather.symbolName)
                            Text("\(pin.weather.temperature)")
                                .font(.system(size: 15))
                        }
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(Color(red: 0.2353, green: 0.2353, blue: 0.2627).opacity(0.3))
                        }
                    }
                    .padding()
                    artwork
                    archiveInfo
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("Music에서 열기")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(red: 0.2353, green: 0.2353, blue: 0.2627).opacity(0.6))
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                    }
                    .background(Color(red: 0.4627, green: 0.4627, blue: 0.502).opacity(0.12))
                    .cornerRadius(10)
                    .padding(.top, 88)
                    .padding(.horizontal, 10)
                    
                    Button {
                        
                    } label: {
                        Text("삭제")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                    }
                    .background(Color(red: 0.4627, green: 0.4627, blue: 0.502).opacity(0.12))
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
                }
                .scrollDisabled(true)
                .listStyle(.inset)
            }
            
        }
        
        
    }
    
    var artwork: some View {
        Rectangle()
            .frame(width: 180, height: 180)
            .foregroundColor(Color(uiColor: .systemGray4))
            .overlay {
                if let artwork = pin.music.artwork {
                    AsyncImage(url: artwork) { image in
                        image.resizable()
                            .frame(width: 180, height: 180)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 180, height: 180)
                    }
                    
                }
            }
            .cornerRadius(8)
    }
    
    var archiveInfo: some View {
        VStack(spacing: 0) {
            Text(pin.music.title)
                .font(.system(size: 20, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.leading, 10)
                .padding(.trailing, 10)
            Text(pin.music.artist)
                .font(.system(size: 15, weight: .regular))
                .padding(.bottom, 10)
            Text("\(pin.location.locality) · \(pin.location.subLocality)")
                .font(.system(size: 15, weight: .regular))
                .padding(.bottom, 4)
            Text(pin.createdAt.dialogFormat)
                .font(.system(size: 15, weight: .regular))
        }
    }
}
//
//struct ArchiveInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArchiveInfoView(pin: Pin(id: "172", count: 3, music: Music(id: "123", title: "Sometimes", artist: "Crush", artwork: URL(string: "https://is3-ssl.mzstatic.com/image/thumb/Music124/v4/d0/f9/7f/d0f97ffc-6051-1240-9647-ff0c76a584a8/81311607.jpg/500x500bb.jpg") , appleMusicUrl: URL(string: "https://music.apple.com/kr/album/sometimes/1624014208?i=1624014209&l=en")), weather: Weather(id: "123", temperature: 18, symbolName: "sun.max"), createdAt: Date(), location: Location(id: "22", latitude: 36.015282, longitude: 129.323173, locality: "포항시", subLocality: "지곡동")))
//    }
//}
