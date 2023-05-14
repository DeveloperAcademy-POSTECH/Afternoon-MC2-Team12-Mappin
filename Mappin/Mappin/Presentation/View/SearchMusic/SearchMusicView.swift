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

    let store: StoreOf<SearchMusicReducer>
    @ObservedObject var viewStore: ViewStoreOf<SearchMusicReducer>
    
    init(store: StoreOf<SearchMusicReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
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
                                        viewStore.send(.searchMusicPresent(isPresented: false))
                                    }, label: {
                                        Text("취소")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.red)
                                    }),
                                trailing:
                                    Button(action: {
                                        viewStore.send(.uploadMusic)
                                    }, label: {
                                        Text("추가")
                                            .font(.system(size: 16, weight: viewStore.selectedMusicIndex == "" ? .regular : .bold))
                                            .foregroundColor(viewStore.selectedMusicIndex == "" ? .gray : .accentColor)
                                    })
                                        .disabled(viewStore.selectedMusicIndex == "")
                                        .onAppear(perform: {
                                            print("@Kozi - \(viewStore.selectedMusicIndex)")
                                        })
            )
            .onAppear {
                settingMuesicAuthorization()
                print("@Kozi - \(MusicAuthorization.currentStatus)")
            }
            .task {
                viewStore.send(.requestMusicChart)
            }
        }
    }
    
    var searchBar: some View {
         HStack {
             HStack {
                 Image(systemName: "magnifyingglass")
                 TextField("Search", text: viewStore.binding(get: \.searchTerm,
                                                             send: SearchMusicReducer.Action.searchTermChanged))
                     .foregroundColor(.primary)
                     .frame(height: 36)
                 if !viewStore.searchTerm.isEmpty {
                     Button(action: {
                         viewStore.send(.resetSearchTerm)
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
                ForEach(!viewStore.searchTerm.isEmpty ? viewStore.searchMusic : viewStore.musicChart) { music in
                    let isSelected = viewStore.selectedMusicIndex == music.id // selectedMusicIndex == "" -> 초기 상태, 검색했거나 검색창을 켰을 경우. checkmark와 이중 클릭 확인을 하기 위함
                    SearchMusicCell(music: music, isSelected: isSelected)
                        .onTapGesture {
                            if isSelected {
                                viewStore.send(.musicCanceled)
                            } else {
                                viewStore.send(.musicSelected(music.id))
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
