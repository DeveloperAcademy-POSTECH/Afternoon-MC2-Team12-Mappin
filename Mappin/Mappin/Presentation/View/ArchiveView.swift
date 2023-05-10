//
//  ArchiveView.swift
//  Mappin
//
//  Created by 예슬 on 2023/05/10.
//

import SwiftUI

struct ArchiveView: View {
    @Binding var isArchiveViewPresented: Bool
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing: 15){
                HStack {
                    Text("내가 저장한 핀들 돌아보기")
                        .bold()
                    Spacer()
                    Button{
                        isArchiveViewPresented.toggle()
                    } label: {
                        Text("취소")
                    }
                    .foregroundColor(.black)
                }
                .padding(.trailing, 16)
                
                myArchiveList()
            }
            .padding(.leading, 16)
            .padding(.top, 26)
        }
        .background(content: {
            Rectangle()
                .fill(.white)
        })
        
        .presentationDetents([.medium, .fraction(0.61), .height(100)])
        .interactiveDismissDisabled(true)
    }
}

@ViewBuilder
func myArchiveList()-> some View {
    VStack(spacing: 15) {
        ForEach(albums){album in
            VStack {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))
                    .frame(height: 1)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(height: 1)
                
                HStack(spacing: 12){
                    Image(album.albumImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text(album.albumName)
                            .fontWeight(.semibold)
                        
                        Text("노래, LANY")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
            }
        }
    }
    .padding(.leading, 15)
}

//struct ArchiveView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArchiveView()
//    }
//}
