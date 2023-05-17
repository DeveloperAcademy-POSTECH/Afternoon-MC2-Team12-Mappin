//
//  PopUpView.swift
//  Mappin
//
//  Created by kio on 2023/05/16.
//

import SwiftUI

struct PopUpView: View {
    
    var pin: Pin
    var cancelContent: () -> Void
    
    var body: some View {
        
        ZStack {
            Image("popUpBackGround")
                .offset(y: 15)
            
            ZStack(alignment: .top) {
                HStack {
                    HStack(spacing: 5) {
                        Image(systemName: pin.weather.symbolName)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(red: 247 / 255, green: 206 / 255, blue: 69 / 255))
                        Text("\(pin.weather.temperature)°")
                            .font(.system(size: 15))
                    }
                    Spacer()
                    Button {
                        cancelContent()
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(Color(red: 0.2353, green: 0.2353, blue: 0.2627).opacity(0.3))
                    }
                    
                }
                .offset(y: -17)
                VStack(spacing: 10) {
                    artwork
                    archiveInfo
                }
            }
            .padding(14)
            .frame(width: 320, height: 320)
        }
        .frame(width: 320, height: 333)
    }
    
    var artwork: some View {
        Rectangle()
            .frame(width: 175, height: 175)
            .foregroundColor(Color(uiColor: .systemGray4))
            .overlay {
                if let artwork = pin.music.artwork {
                    ZStack(alignment: .bottomTrailing) {
                        AsyncImage(url: artwork) { image in
                            image.resizable()
                                .frame(width: 175, height: 175)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 175, height: 175)
                        }
                        .overlay {
                            Image("PopUpImageCover")
                        }
                        Text("Music에서 열기")
                            .foregroundColor(.white)
                            .font(.system(size: 11))
                            .underline()
                            .onTapGesture {
                                if let url = pin.music.appleMusicUrl {
                                    openAppleMusic(url: url)
                                }
                            }
                            .offset(x: -17, y: -17)
                    }
                }
            }
            .cornerRadius(9)
    }
    
    var archiveInfo: some View {
        VStack(spacing: 12) {
            VStack(spacing: 2) {
                Text(pin.music.title)
                    .font(.system(size: 20, weight: .semibold))
                Text(pin.music.artist)
                    .font(.system(size: 15))
                    .foregroundColor(Color(red: 0.2353, green: 0.2353, blue: 0.2627).opacity(0.6))
            }
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            
            VStack(spacing: 4) {
                HStack(spacing: 2) {
                    Text(pin.location.locality)
                    Text("·")
                        .fontWeight(.bold)
                    Text(pin.location.subLocality)
                }
                HStack(spacing: 2) {
                    Text(pin.createdAt.weekday)
                    Text("·")
                        .fontWeight(.bold)
                    Text(pin.createdAt.yearAndMonth)
                    Text("·")
                        .fontWeight(.bold)
                    Text(pin.createdAt.time)
                }
            }
            .font(.system(size: 13))
        }
    }
    
    func openAppleMusic(url: URL?) {
        guard let appleMusicUrl = url,
              UIApplication.shared.canOpenURL(appleMusicUrl)
        else {
            print("URL이 없는 음악이거나, URL을 열 수 없음.")
            return
        }
        UIApplication.shared.open(appleMusicUrl)
    }
}

struct ArchiveInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PopUpView(pin: Pin(id: 172, count: 3, music: Music(id: "123", title: "Sometimes", artist: "Crush", artwork: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music122/v4/b7/92/a8/b792a86d-fc61-23f1-427d-3b635f0f5e83/8809887700209.jpg/300x300bb.jpg") , appleMusicUrl: URL(string: "https://music.apple.com/kr/album/sometimes/1624014208?i=1624014209&l=en")), weather: Weather(temperature: 18, symbolName: "sun.max"), createdAt: Date(), location: Location(latitude: 36.015282, longitude: 129.323173, locality: "포항시", subLocality: "지곡동"))) {
            print("")
        }
    }
}
