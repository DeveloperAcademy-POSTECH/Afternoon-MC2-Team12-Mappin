//
//  PrimaryView.swift
//  Mappin
//
//  Created by 예슬 on 2023/05/08.
//

import SwiftUI

struct PrimaryView: View {
    @State private var isSearchMusicViewPresented = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                MapView(action: .constant(.none), userTrackingMode: .follow)
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    Button("현재 위치에 음악 핀하기") {
                        isSearchMusicViewPresented.toggle()
                    }
                    .applyButtonStyle()
                    .sheet(isPresented: $isSearchMusicViewPresented) {
                        SearchMusicView1(isSearchMusicViewPresented: $isSearchMusicViewPresented)
                    }
                    
                    NavigationLink("내 핀과 다른 사람들 핀 구경하기") {
                        ArchiveMapView.build()
                    }
                    .applyButtonStyle()
                }
                .font(.system(size: 16, weight: .semibold))
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
    }
}

private extension View {
    func applyButtonStyle() -> some View {
        modifier(ButtonStyleModifier())
    }
}

private struct ButtonStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(.white)
            .cornerRadius(10)
    }
}

struct PrimaryView_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryView()
    }
}
