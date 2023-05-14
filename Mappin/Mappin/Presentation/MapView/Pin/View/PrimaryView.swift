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
                        .onTapGesture {
                            if pinViewStore.state.detailPin != nil {
                                pinViewStore.send(.showPopUpAndCloseAfter)
                            }
                        }
                        .ignoresSafeArea()
                        .opacity(Double(action.yame))
                    
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
                        SearchMusicView(pinStore: pinStore, musicStore: musicStore, settingsDetent: $settingsDetent)
                            .presentationBackgroundInteraction(.enabled)
                            .presentationDetents([.fraction(0.12), .fraction(0.71), .large], selection: $settingsDetent)
                            .interactiveDismissDisabled()
                    }
                }
                if let pin = pinViewStore.state.detailPin{
                    DetailPinPopUpView(pin: pin)
                        .offset(y: 178)
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
