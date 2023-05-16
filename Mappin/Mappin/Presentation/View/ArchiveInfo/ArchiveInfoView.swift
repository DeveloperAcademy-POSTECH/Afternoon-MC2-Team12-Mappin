//
//  ArchiveInfoView.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/16.
//

import SwiftUI

import ComposableArchitecture

struct ArchiveInfoView: View {
    // 357
    @Environment(\.dismiss) var dismiss
//    @StateObject private var listViewStore: ViewStoreOf<ListReducer> = ViewStore(Store(
//        initialState: ListReducer.State(),
//        reducer: ListReducer.build()
//    ), observe: { $0 })
    @ObservedObject var infoViewStore: ViewStoreOf<ArchiveInfoReducer> = ViewStore(Store(initialState: ArchiveInfoReducer.State(pin: nil), reducer: ArchiveInfoReducer(removePinUseCase: DefaultMockDIContainer.shared.container.resolver.resolve(RemovePinUseCase.self))))
    @ObservedObject var mapViewStore: ViewStoreOf<PinMusicReducer>
    
    var pin: Pin
    
    init(pin: Pin, mapViewStore: ViewStoreOf<PinMusicReducer>) {
        self.pin = pin
        self.mapViewStore = mapViewStore
    }

 
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        HStack(spacing: 5) {
                            Image(systemName: pin.weather.symbolName)
                            Text("\(pin.weather.temperature)")
                                .font(.system(size: 15))
                        }
                        Spacer()
                        Button {
                            mapViewStore.send(.detailPinValidate(true))
                            dismiss()
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(Color(red: 0.2353, green: 0.2353, blue: 0.2627).opacity(0.3))
                        }
                    }
                    .padding()
                    artwork
                    archiveInfo
                    Spacer()
                    Button {
                        infoViewStore.send(.openAppleMusic(pin.music.appleMusicUrl!))
                    } label: {
                        Text("Music에서 열기")
                            .font(.system(size: 15, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                    }
                    .background(Color(red: 0.4627, green: 0.4627, blue: 0.502).opacity(0.12))
                    .cornerRadius(10)
                    .padding(.top, 88)
                    .padding(.horizontal, 15)
                    
                    Button {
                        infoViewStore.send(.removeArchive(pin.id))
                    } label: {
                        Text("삭제")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                    }
                    .background(Color(red: 0.4627, green: 0.4627, blue: 0.502).opacity(0.12))
                    .cornerRadius(10)
                    .padding(.horizontal, 15)
                }
            }
            .onAppear {
                print("@Kozi2 - \(ObjectIdentifier(mapViewStore))")
            }
            .onChange(of: infoViewStore.isSomethingRemoved) { _ in
                mapViewStore.send(.refreshPins)
            }
            .scrollDisabled(true)
        }
        
        
    }
    
    var artwork: some View {
        Rectangle()
            .frame(width: 180, height: 180)
            .foregroundColor(Color(uiColor: .systemGray4))
            .overlay {
                if let artwork = pin.music.artwork {
                    AsyncImage(url: artwork) { image in
                        image.resizable()
                            .frame(width: 180, height: 180)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 180, height: 180)
                    }
                    
                }
            }
            .cornerRadius(8)
    }
    
    var archiveInfo: some View {
        VStack(spacing: 0) {
            Text(pin.music.title)
                .font(.system(size: 20, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.horizontal, 10)
            Text(pin.music.artist)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(Color(red: 0.2353, green: 0.2353, blue: 0.2627).opacity(0.6))
                .padding(.bottom, 10)
            Text("\(pin.location.locality) · \(pin.location.subLocality)")
                .font(.system(size: 15, weight: .regular))
                .padding(.bottom, 4)
            Text(pin.createdAt.dialogFormat)
                .font(.system(size: 15, weight: .regular))
        }
    }
}

