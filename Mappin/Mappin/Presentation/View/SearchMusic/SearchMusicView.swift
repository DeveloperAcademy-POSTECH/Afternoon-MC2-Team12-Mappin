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
    
    let pinStore: StoreOf<PinMusicReducer>
    @ObservedObject var pinViewStore: ViewStoreOf<PinMusicReducer>
    
    init(pinStore: StoreOf<PinMusicReducer>, musicStore: StoreOf<SearchMusicReducer>) {
        self.musicStore = musicStore
        self.musicViewStore = ViewStore(self.musicStore, observe: { $0 })
        
        self.pinStore = pinStore
        self.pinViewStore = ViewStore(self.pinStore, observe: { $0 })
    }
    
    var body: some View {
        NavigationView {
            VStack {
                searchMusicList
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading:
                                    Text("현재 위치에 음악 핀하기")
                .font(.system(size: 16, weight: .bold)),
                                trailing:
                                    Button(action: {
                musicViewStore.send(.searchMusicPresent(isPresented: false))
                pinViewStore.send(.actAndChange(.cancelModal(here: (RequestLocationRepository.manager.latitude, RequestLocationRepository.manager.longitude))))
            }, label: {
                Text("취소")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.black)
            }))
            .searchable(text: musicViewStore.binding(get: \.searchTerm, send: SearchMusicReducer.Action.searchTermChanged),
                        placement: .navigationBarDrawer(displayMode: .always) )
            
            .onAppear {
                settingMuesicAuthorization()
                print("@Kozi - \(MusicAuthorization.currentStatus)")
            }
            .task {
                musicViewStore.send(.requestMusicChart)
            }
        }
    }
    
    /// 음악 검색 리스트 구현
    var searchMusicList: some View {
        withAnimation {
            List {
                Section {
                    ForEach(!musicViewStore.searchTerm.isEmpty ? musicViewStore.searchMusic : musicViewStore.musicChart) { music in
                        let isSelected = musicViewStore.selectedMusicIndex == music.id // selectedMusicIndex == "" -> 초기 상태, 검색했거나 검색창을 켰을 경우. checkmark와 이중 클릭 확인을 하기 위함
                        let noSelection = musicViewStore.selectedMusicIndex.isEmpty // 초기 상태, 혹은 유저가 검색을 했을 때. opacity를 주기 위함
                        SearchMusicCell(music: music, isSelected: isSelected, noSelection: noSelection)
                            .onTapGesture {
                                if isSelected {
                                    musicViewStore.send(.uploadMusic)
                                } else {
                                    musicViewStore.send(.musicSelected(music.id))
                                }
                            }
                    }
                } header: {
                    Text(musicViewStore.searchTerm.isEmpty ? "현재 이 지역 음악 추천" : "검색 결과")
                        .padding(.leading, 15)
                    //                        .foregroundColor(.blue)
                    //                        .background(Color.black)
                    //                        .padding(.top, -100)
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
