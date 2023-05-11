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
    
    @State private var searchTerm: String = ""
    @State private var selectedCell: String? = nil
    
    let store: StoreOf<SearchMusicReducer>
    @ObservedObject var viewStore: ViewStoreOf<SearchMusicReducer>
    
    init(store: StoreOf<SearchMusicReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
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
                                        print("취소 버튼 클릭")
                                    }, label: {
                                        Text("취소")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(.black)
                                    }))
            .searchable(text: viewStore.binding(get: \.searchTerm, send: MusicReducer.Action.searchTermChanged),
                        placement: .navigationBarDrawer(displayMode: .always))
            .onAppear {
                settingMuesicAuthorization()
                print(MusicAuthorization.currentStatus)
            }
            .task {
                viewStore.send(.requestMusicChart)
            }
        }
    }
    
    /// 음악 검색 리스트 구현
    var searchMusicList: some View {
        withAnimation {
            List {
                Section {
                    ForEach(!viewStore.searchTerm.isEmpty ? viewStore.searchMusic : viewStore.musicChart) { music in
                        let isSelected = viewStore.selectedMusicIndex == music.id // selectedMusicIndex == "" -> 초기 상태, 검색했거나 검색창을 켰을 경우. checkmark와 이중 클릭 확인을 하기 위함
                        let noSelection = viewStore.selectedMusicIndex.isEmpty // 초기 상태, 혹은 유저가 검색을 했을 때. opacity를 주기 위함
                        SearchMusicCell(music: music, isSelected: isSelected, noSelection: noSelection)
                            .onTapGesture {
                                if isSelected {
                                    viewStore.send(.uploadMusic)
                                } else {
                                    viewStore.send(.musicSelected(music.id))
                                }
                        }
                    }
                } header: {
                    Text(viewStore.searchTerm.isEmpty ? "현재 이 지역 음악 추천" : "검색 결과")
                        .padding(.leading, 15)
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
