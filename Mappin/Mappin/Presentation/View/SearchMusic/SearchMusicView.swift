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
    
    let store: StoreOf<MusicReducer>
    @ObservedObject var viewStore: ViewStoreOf<MusicReducer>
    
    init(store: StoreOf<MusicReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }
    
    var body: some View {
        VStack {
            titleWithCancel
            searchBar
            searchMusicList
        }
        .onAppear {
            settingMuesicAuthorization()
        }
        .task {
            viewStore.send(.requestMusicChart)
        }
    }
    
    /// 최상단 뷰(타이틀, 취소버튼) 구현
    var titleWithCancel: some View {
        HStack {
            Text("현재 위치에 음악 핀하기")
                .font(.system(size: 16,
                              weight: .bold))
                .padding(.leading, 16)
            Spacer()
            Button {
                
            } label: {
                Text("취소")
                    .font(.system(size: 16,
                                  weight: .regular))
                    .foregroundColor(.black)
                    .padding(.trailing, 16)
            }
        }
        .padding(.top, 19)
    }
    
    /// SearchBar 구현
    var searchBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: viewStore.binding(get: \.searchTerm,
                                                            send: MusicReducer.Action.searchTermChanged))
                    .foregroundColor(.primary)
                    .frame(height: 36)
                if !viewStore.searchTerm.isEmpty {
                    Button(action: {
                        viewStore.send(.resetSearchTerm)
                        viewStore.send(.requestMusicChart)
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
    
    var searchMusicList: some View {
        List(viewStore.music) { music in
            SearchMusicCell(music: music)
        }
        .scrollContentBackground(.hidden)
    }
    
    func settingMuesicAuthorization() {
        Task {
            _ = await MusicAuthorization.request()
        }
    }
    
}



//struct SearchMusicView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchMusicView()
//    }
//}
