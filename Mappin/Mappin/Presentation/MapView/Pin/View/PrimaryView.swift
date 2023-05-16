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
    
    @State private var settingsDetent = PresentationDetent.fraction(0.71)
    
    let pinStore: StoreOf<PinMusicReducer> // scope
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
            ZStack(alignment: .top) {
                TCABindView(firstSendEntity: musicViewStore.state.uploadMusic, secondSendEntity: pinViewStore.state.temporaryPinLocation) { music, location  in
                    pinViewStore.send(.addPin(music: music!, latitude: location!.center.latitude, longitude: location!.center.longitude))
                }
                ZStack(alignment: .bottom) {
                    MapView(action: .constant(.none), store: pinViewStore, userTrackingMode: .follow)
                        .ignoresSafeArea()
                        
                    
                    VStack(spacing: 10) {
                        Button(action: {
                            musicViewStore.send(.searchMusicPresent(isPresented: true))
                            pinViewStore.send(
                                .actAndChange(
                                    .setCenterWithModalAndAddTemporaryPin(
                                        latitude:
                                            RequestLocationRepository.manager.latitude,
                                        longitude:  RequestLocationRepository.manager.longitude
                                        
                                    )
                                )
                            )
                        }, label: {
                            Text("현재 위치에 감정 기록하기")
                                .applyButtonStyle()
                        })
                        
                        NavigationLink(destination: {
                            ArchiveMapView.build()
                        }, label: {
                            Text("나와 다른 사람의 기록 살펴보기")
                                .applyButtonStyle()
                        })
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                    .shadow(color: Color.black.opacity(0.3), radius: 100, y: 10)
                    .opacity(musicViewStore.isSearchMusicPresented ? 0 : 1)
                    .animation(.easeInOut, value: musicViewStore.isSearchMusicPresented)
                    .sheet(isPresented: musicViewStore.binding(get: \.isSearchMusicPresented,
                                                               send: { .searchMusicPresent(isPresented: $0) })) {
                        SearchMusicView(pinStore: pinStore, musicStore: musicStore, settingsDetent: $settingsDetent)
                            .presentationBackgroundInteraction(.enabled)
                            .presentationDetents([.fraction(0.71), .large], selection: $settingsDetent)
                            .interactiveDismissDisabled()
                    }
                }
                if let pin = pinViewStore.state.detailPin {
                    PopUpView(pin: pin) {
                        pinViewStore.send(.showPopUpAndCloseAfter)
                    }
                    
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
            .frame(height: 50)
            .font(.system(size: 16, weight: .bold))
            .background(.white)
            .cornerRadius(12)
    }
}

struct TCABindView<FirstEntityType: Equatable, SencondEntityType>: View {
    
    var firstSendEntity: FirstEntityType?
    var secondSendEntity: SencondEntityType?
    var content: (FirstEntityType?, SencondEntityType?) -> Void
    
    init(firstSendEntity: FirstEntityType?,
         secondSendEntity: SencondEntityType?,
         content: @escaping (FirstEntityType?, SencondEntityType?) -> Void) {
        self.firstSendEntity = firstSendEntity
        self.secondSendEntity = secondSendEntity
        self.content = content
    }
    
    var body: some View {
        EmptyView()
            .opacity(Double((1...1000).randomElement()!))
            .onChange(of: firstSendEntity) { temp in
                content(temp, self.secondSendEntity)
            }
    }
}
