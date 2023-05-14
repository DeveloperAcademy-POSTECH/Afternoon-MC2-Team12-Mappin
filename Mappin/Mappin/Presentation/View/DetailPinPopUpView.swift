//
//  PopOverView.swift
//  Mappin
//
//  Created by 예슬 on 2023/05/11.
//

import SwiftUI

struct DetailPinPopUpView: View {
    
    var pin: Pin

    var body: some View {
        VStack{
            ImageTitleArtistLocation
                .padding(.top, 19)
            HStack(alignment: .bottom) {

                Button {
                    if let url = pin.music.appleMusicUrl {
                        openAppleMusic(url: url)
                    }
                } label: {
                    HStack {
                        Image("appleMusic")
                        HStack {
                            Text("Music에서 열기")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(Color(red: 0.6824,
                                                       green: 0.6824,
                                                       blue: 0.698))
                                
                            Image(systemName: "arrow.up.forward")
                                .resizable()
                                .frame(width: 9, height: 9)
                                .foregroundColor(Color(red: 0.6824,
                                                       green: 0.6824,
                                                       blue: 0.698))
                                .padding(.leading, -7)
                        }
                        .frame(width: 100, height: 15)
                        .padding(.top, 1)
                        .padding(.leading, -15)
                    }
                }
                .padding(.leading, 2)
                .padding(.bottom, 10)
                
                Spacer()
                
                Label {
                    Text(String(pin.weather.temperature) + "º" )
                        .font(.system(size: 13))
//                        .padding(.trailing, 5)
                        .padding(.leading, -6)
                } icon: {
                    Image(systemName: pin.weather.symbolName)
                        .renderingMode(.original)
                }
                .frame(width: 50, height: 32)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(6)
                
            }
            .padding(.bottom, 20)
            
        }
        .frame(width: 290, height: 180)
        .padding(.bottom, 30)
        .background(
            Image("popUpBackGround")
        )
    }
    
    var ImageTitleArtistLocation: some View {
        HStack {
            if let artwork = pin.music.artwork {
                AsyncImage(url: artwork) { image in
                    image.image?.resizable()
                        .frame(width: 105, height: 105)
                        .cornerRadius(8)
                }
            }
            
            VStack(alignment: .leading){
                Text(pin.music.title)
                    .font(.system(size: 17, weight: .semibold))
                    .padding(.leading, 7)
                
                Text("노래 ∙ \(pin.music.artist)")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .padding(.leading, 7)
                
                
                VStack(alignment: .leading){
                    Text("\(pin.createdAt)")
                        .font(.system(size: 10))
                        .padding(.leading, 5)
                    Divider()
                    Label{
                        Text("\(pin.location.locality) · \(pin.location.subLocality)")
                            .font(.system(size: 10))
                            .padding(.leading, -3)
                    } icon: {
                        Image(systemName: "location.fill")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.accentColor)
//                            .frame(width: 6, height: 9)
                    }
                    .padding(.leading, 5)
                }
                .padding(10)
                .background(.gray.opacity(0.1))
                .cornerRadius(8)
            }
            .padding(.top, 5)
            .padding(.leading, 2)
            
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

struct DetailPinPopUpView_Previews: PreviewProvider {
    static var previews: some View {
        DetailPinPopUpView()
    }
}

