//
//  PrimaryView.swift
//  Mappin
//
//  Created by 예슬 on 2023/05/08.
//

import SwiftUI

import ComposableArchitecture
import MapKit

struct PrimaryView: View {
    
    @State private var isSearchMusicViewPresented = false
    
    let pinStore: StoreOf<PinMusicReducer>
    let musicStore: StoreOf<MusicReducer>
    
    @ObservedObject var viewStore: ViewStoreOf<PinMusicReducer>
    @State var action: MapView.Action = .none
    
    init(store: StoreOf<PinMusicReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                MapView(action: .constant(.none), store: viewStore, userTrackingMode: .follow)
                    .ignoresSafeArea()
                    .opacity(Double(action.yame))
                
                VStack(spacing: 10) {
                    
                    Button("현재 위치에 음악 핀하기") {
                        withAnimation {
                            isSearchMusicViewPresented.toggle()
                        }
                    }
                    .applyButtonStyle()
                    .opacity(isSearchMusicViewPresented ? 0 : 1)
                    .sheet(isPresented: $isSearchMusicViewPresented) {
                        SearchMusicView(store: Store(initialState: <#T##ReducerProtocol.State#>, reducer: <#T##ReducerProtocol#>))
                            .presentationBackgroundInteraction(.enabled)
                    }
                    NavigationLink("내 핀과 다른 사람들 핀 구경하기") {
                        ArchiveMapView.build()
                    }
                    .applyButtonStyle()
                    .opacity(isSearchMusicViewPresented ? 0 : 1)
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

