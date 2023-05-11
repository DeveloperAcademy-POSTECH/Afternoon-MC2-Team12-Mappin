//
//  PrimaryView.swift
//  Mappin
//
//  Created by 예슬 on 2023/05/08.
//

import SwiftUI

struct PrimaryView: View {
    
    @State private var isSearchMusicViewPresented = false
    @State private var isArchiveViewPresented = false
    
    var body: some View {
        VStack{
            
            Spacer()
            
            Button("현재 위치에 음악 핀하기"){
                isSearchMusicViewPresented.toggle()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .sheet(isPresented: $isSearchMusicViewPresented) {
                SearchMusicView(isSearchMusicViewPresented: $isSearchMusicViewPresented)
            }
            
            
            
            Button("내 핀과 다른 사람들 핀 구경하기"){
                isArchiveViewPresented.toggle()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
        }
        .padding(15)
    }
}


//struct PrimaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        PrimaryView()
//    }
//}
