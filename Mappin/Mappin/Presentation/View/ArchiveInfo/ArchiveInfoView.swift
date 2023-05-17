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
    @ObservedObject var infoViewStore: ViewStoreOf<ArchiveInfoReducer> = ViewStore(Store(initialState: ArchiveInfoReducer.State(pin: nil), reducer: ArchiveInfoReducer(removePinUseCase: DefaultMockDIContainer.shared.container.resolver.resolve(RemovePinUseCase.self))))
    @ObservedObject var mapViewStore: ViewStoreOf<PinMusicReducer>
    
    var pin: Pin
    var category: PinsCategory?
    
    init(pin: Pin, mapViewStore: ViewStoreOf<PinMusicReducer>) {
        self.pin = pin
        self.mapViewStore = mapViewStore
        if let category = mapViewStore.category {
            self.category = category
        }
    }

 
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        HStack(spacing: 5) {
                            Image(systemName: pin.weather.symbolName)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Color(red: 247 / 255, green: 206 / 255, blue: 69 / 255))
                            Text("\(pin.weather.temperature)°")
                                .font(.system(size: 15))
                        }
                        Spacer()
                        Button {
                            mapViewStore.send(.toggleDetailPin(false))
                            dismiss()
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(Color(red: 0.2353, green: 0.2353, blue: 0.2627).opacity(0.3))
                        }
                    }
                    .padding()
                    
                    VStack(spacing: 10) {
                        artwork
                        archiveInfo
                    }
                    
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
                    .padding(.top, category == .mine ? 88 : 149)
                    .padding(.horizontal, 15)
                    
                    // 다른 사람 핀 볼 경우 삭제 버튼 ishidden
                    Button {
                        infoViewStore.send(.removeArchive(pin.id))
                        mapViewStore.send(.toggleDetailPin(false))
                        dismiss()
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
                    .opacity(category == .mine ? 1.0 : 0)
                }
            }
            .onAppear {
                infoViewStore.send(.setPin(pin))
                if category != nil {
                    infoViewStore.send(.setCategory(category!))
                }
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
            .cornerRadius(9)
    }
    
    var archiveInfo: some View {
        VStack(spacing: 12) {
            VStack(spacing: 2) {
                Text(pin.music.title)
                    .font(.system(size: 20, weight: .semibold))
                Text(pin.music.artist)
                    .font(.system(size: 15))
                    .foregroundColor(Color(red: 0.2353, green: 0.2353, blue: 0.2627).opacity(0.6))
            }
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            
            VStack(spacing: 4) {
                HStack(spacing: 2) {
                    Text(pin.location.locality)
                    Text("·")
                        .fontWeight(.bold)
                    Text(pin.location.subLocality)
                }
                HStack(spacing: 2) {
                    Text(pin.createdAt.weekday)
                    Text("·")
                        .fontWeight(.bold)
                    Text(pin.createdAt.yearAndMonth)
                    Text("·")
                        .fontWeight(.bold)
                    Text(pin.createdAt.time)
                }
            }
            .font(.system(size: 13))
        }
    }
}
