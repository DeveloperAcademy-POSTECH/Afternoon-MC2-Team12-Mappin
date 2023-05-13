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
    
    @State private var settingsDetent = PresentationDetent.medium
    
    let pinStore: StoreOf<PinMusicReducer>
    let musicStore: StoreOf<SearchMusicReducer>
    
    @ObservedObject var pinViewStore: ViewStoreOf<PinMusicReducer>
    @ObservedObject var musicViewStore: ViewStoreOf<SearchMusicReducer>
    @State var action: MapView.Action = .none
    @State var tempClose: Bool = false
    
    
    init(pinStore: StoreOf<PinMusicReducer>, musicStore: StoreOf<SearchMusicReducer>) {
        self.pinStore = pinStore
        self.pinViewStore = ViewStore(self.pinStore, observe: { $0 })
            
            
        self.musicStore = musicStore
        self.musicViewStore = ViewStore(self.musicStore, observe: { $0 })
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                MapView(action: .constant(.none), store: pinViewStore, userTrackingMode: .follow)
                    .ignoresSafeArea()
                    .opacity(Double(action.yame))
                
                VStack(spacing: 10) {
                    Button(action: {
                        musicViewStore.send(.searchMusicPresent(isPresented: true))
                    }, label: {
                        Text("현재 위치에 음악 핀하기")
                    })
                    .applyButtonStyle()
                    .opacity(musicViewStore.isSearchMusicPresented ? 0 : 1)
                    NavigationLink("내 핀과 다른 사람들 핀 구경하기") {
                        ArchiveMapView.build()
                    }
                    .applyButtonStyle()
                    .opacity(musicViewStore.isSearchMusicPresented ? 0 : 1)
                }
                .font(.system(size: 16, weight: .semibold))
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
                .sheet(isPresented: musicViewStore.binding(get: \.isSearchMusicPresented,
                                                           send: { .searchMusicPresent(isPresented: $0) })) {
                    SearchMusicView(self, store: musicStore)
                        .presentationBackgroundInteraction(.enabled)
                        .presentationDetents([.fraction(0.12), .medium, .large], selection: $settingsDetent)
                        .interactiveDismissDisabled()
                }
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

extension PrimaryView {

    func passMusic() {
        musicViewStore.send(.initParent(self))
        musicViewStore.send(.uploadMusic)
        print("@Log add")
    }
    
    func sendPin(_ music: Music?) {
        guard let music = music else {
            print("@LOG Error Add")
            return
        }

        pinViewStore.send(.addPin(music: music, latitudeDelta: MapView.Constants.defaultLatitudeDelta, longitudeDelta: MapView.Constants.defaultLatitudeDelta))
    }
}
