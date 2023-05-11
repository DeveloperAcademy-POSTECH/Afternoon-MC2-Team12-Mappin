//
//  SearchMusicView.swift
//  Mappin
//
//  Created by 예슬 on 2023/05/08.
//

import SwiftUI

struct SearchMusicView1: View {
    
    @Binding var isSearchMusicViewPresented: Bool
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing: 15){
                HStack {
                    Text("현재 위치에 음악 핀하기")
                        .bold()
                    
                    Spacer()
                    
                    Button{
                        isSearchMusicViewPresented.toggle()
                    } label: {
                        Text("취소")
                    }
                    .foregroundColor(.black)
                    
                }
                .padding(.trailing, 16)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search", text:
                            .constant(""))
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.ultraThickMaterial)
                }
                .padding(.trailing, 16)
                
                    HStack{
                        Text("현재 이 지역 음악 추천")
                            .font(.subheadline.bold())
                        Spacer()
                    }
                    .padding(.top, 26)
                    .padding(.leading, 15)
                                    
                musicList()
                
            }
            .padding(.leading, 16)
            .padding(.top, 16)
            
        }
        
        .background(content: {
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
        })
        //        .font(.title3)
        //        .presentationBackground(.ultraThickMaterial)
        //
        //        .presentationDetents([.height(100), .medium, .large], selection: $showAnotherSheet[index])
        .presentationDetents([.medium, .fraction(0.61), .height(100)])
        //        .presentationBackgroundInteraction(.enabled)
        .interactiveDismissDisabled(true)
    }
}
    
    
    @ViewBuilder
    func musicList()->some View{
        VStack(spacing: 15){
            ForEach(albums){album in
                VStack {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                        .frame(height: 1)
                    
//                    Divider()
//                        .frame(maxWidth: .infinity, alignment: .trailing)
//                        .foregroundColor(.black)
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 1)
                    
                    HStack(spacing:12){
//                        Text("#\(getIndex(album: album) + 1)")
//                            .fontWeight(.semibold)
                        
                        Image(album.albumImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        
                        VStack(alignment: .leading, spacing: 10){
                            Text(album.albumName)
                                .fontWeight(.semibold)
                            
                            Text("노래, LANY")
//                            Label{
//                                Text("노래, LANY")
//                            } icon: {
//                                Image(systemName: "beats.headphones")
//                            }
                            .font(.caption)
                        }
                        .frame(maxWidth:.infinity, alignment: .leading)
                        
                        Button{
                            album.isLiked.toggle()
                            
                        } label:{
                            Image(systemName: album.isLiked ? "checkmark" : "plus")
                                .padding(.trailing, 30)
                                .font(.title3)
                                .foregroundColor(album.isLiked ? .blue :.primary)
                        }
                        
//                        Button{
//
//                        } label: {
//                            Image(systemName: "ellipsis")
//                                .font(.title3)
//                                .foregroundColor(.primary)
//                        }
                    }
                }
            }
        }
        .padding(.leading,15)
    }
    
//    func getIndex(album: Album)-> Int {
//        return albums.firstIndex { CALbum in
//            CALbum.id == album.id
//        } ?? 0
//    }

//struct SearchMusicView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchMusicView()
//    }
//}

