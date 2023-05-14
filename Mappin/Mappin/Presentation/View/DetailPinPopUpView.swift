//
//  PopOverView.swift
//  Mappin
//
//  Created by 예슬 on 2023/05/11.
//

import SwiftUI

struct DetailPinPopUpView: View {
    
    var pin: Pin?

    var body: some View {
        VStack{
            HStack {
                AsyncImage(url: pin?.music.artwork ??
                           URL(string: "https://is3-ssl.mzstatic.com/image/thumb/Music116/v4/af/2c/6d/af2c6d62-0ebc-2dff-17b3-8eeb2b3986a0/888735943621.jpg/200x200bb.jpg")
                )
                    .frame(width: 105, height: 105)
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                
                Spacer()
                    .frame(width: 12)
                
                VStack(alignment: .leading){
                    Text(pin?.music.title ?? "빗속에서")
                        .font(.system(size: 16))
                        .bold()
                    
                    Spacer()
                        .frame(height: 5)
                    Text("노래·\(pin?.music.artist ?? "이문세")")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    VStack(alignment: .leading){
                        Text("\(pin?.createdAt ?? Date())")
                            .font(.system(size: 10))
                        Divider()
                        //.frame(width: 200)
                        
                        Label{
                            Text("\(pin?.location.locality ?? "사랑시")·\(pin?.location.subLocality ?? "고백구 행복동")")
                                .font(.system(size: 10))
                        } icon: {
                            Image("Location")
                                .frame(width: 6, height: 9)
                        }
                        
                    }
                    .padding(10)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(9)
                    
                    
                }
                .frame(height:105)
            }
            .padding(.bottom,5)
            .padding(.top, 19)
            
            
            HStack(alignment: .bottom){
                Button {
                    print("apple music")
                } label: {
                    Text("애플 뮤직에서 열기")
                }
                
                Spacer()
                
                Label{
                    if let temperature = pin?.weather.temperature {
                        Text(String(temperature) + "º" )
                    }
                } icon: {
                    Image(systemName: pin?.weather.symbolName ?? "sun.max.fill")
                        .foregroundColor(.yellow)
                }
                .padding(8)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(6)
                
            }
            .padding(.bottom, 20)
            
        }
        .frame(width: 290, height: 180)
        .padding(.bottom, 30)
        .background(Image("popUpBackGround"))
    }
}
