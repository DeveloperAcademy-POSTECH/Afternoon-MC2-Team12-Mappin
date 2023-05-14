//
//  SearchMusicView.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/09.
//

import SwiftUI

import ComposableArchitecture
import MusicKit

struct SearchMusicView: View {
    
    let musicStore: StoreOf<SearchMusicReducer>
    @ObservedObject var musicViewStore: ViewStoreOf<SearchMusicReducer>
    @Binding private var settingsDetent: PresentationDetent
    
    let pinStore: StoreOf<PinMusicReducer>
    @ObservedObject var pinViewStore: ViewStoreOf<PinMusicReducer>
    
    init(pinStore: StoreOf<PinMusicReducer>, musicStore: StoreOf<SearchMusicReducer>, settingsDetent: Binding<PresentationDetent>) {
        self.musicStore = musicStore
        self.musicViewStore = ViewStore(self.musicStore, observe: { $0 })
        self._settingsDetent = settingsDetent
        
        self.pinStore = pinStore
        self.pinViewStore = ViewStore(self.pinStore, observe: { $0 })
    }
    
    var body: some View {
        NavigationView {
            VStack {
                searchBar
                    .padding(.bottom, 15)
                Divider()
                searchMusicList
            }
            .navigationBarTitle("현재 위치에 음악 핀하기", displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {
                musicViewStore.send(.searchMusicPresent(isPresented: false))
                pinViewStore.send(.actAndChange(.cancelModal(latitude: RequestLocationRepository.manager.latitude, longitude: RequestLocationRepository.manager.longitude)))
            }, label: {
                Text("취소")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.red)
            }),
                                trailing:
                                    Button(action: {
                musicViewStore.send(.uploadMusic)
            }, label: {
                Text("추가")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(musicViewStore.selectedMusicIndex == "" ? .gray : .accentColor)
            })
                                        .disabled(musicViewStore.selectedMusicIndex == "")
                                        .onAppear(perform: {
                                            print("@Kozi - \(musicViewStore.selectedMusicIndex)")
                                        })
            )
            .onChange(of: settingsDetent) { newValue in
                if newValue == .fraction(0.12) {
                    pinViewStore.send(.modalMinimumHeight(false))
                }
                else {
                    pinViewStore.send(.modalMinimumHeight(true))
                }
            }
            .onAppear {
                settingMuesicAuthorization()
                print("@Kozi - \(MusicAuthorization.currentStatus)")
            }
            .task {
                musicViewStore.send(.requestMusicChart)
            }
        }
    }
    
    var searchBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: musicViewStore.binding(get: \.searchTerm,
                                                                 send: SearchMusicReducer.Action.searchTermChanged))
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.primary)
                .frame(height: 36)
                .onTapGesture {
                    settingsDetent = PresentationDetent.fraction(0.71)
                }
                
                if !musicViewStore.searchTerm.isEmpty {
                    Button(action: {
                        musicViewStore.send(.resetSearchTerm)
                    }) {
                        Image(systemName: "xmark.circle.fill")
                    }
                } else {
                    EmptyView()
                }
                
            }
            .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
            .foregroundColor(Color(red: 0.5569,
                                   green: 0.5569,
                                   blue: 0.5765))
            .background(Color(red: 0.9216,
                              green: 0.9216,
                              blue: 0.9412))
            .cornerRadius(10.0)
        }
        .padding(.horizontal)
    }
    
    /// 음악 검색 리스트 구현
    var searchMusicList: some View {
        withAnimation {
            List {
                ForEach(!musicViewStore.searchTerm.isEmpty ? musicViewStore.searchMusic : musicViewStore.musicChart) { music in
                    let isSelected = musicViewStore.selectedMusicIndex == music.id // selectedMusicIndex == "" -> 초기 상태, 검색했거나 검색창을 켰을 경우. checkmark와 이중 클릭 확인을 하기 위함
                    SearchMusicCell(music: music, isSelected: isSelected)
                        .onTapGesture {
                            if isSelected {
                                musicViewStore.send(.musicCanceled)
                            } else {
                                musicViewStore.send(.musicSelected(music.id))
                            }
                        }
                }
            }
            
            .listStyle(.inset)
        }
    }
    
    func settingMuesicAuthorization() {
        Task {
            _ = await MusicAuthorization.request()
        }
    }
    
}
