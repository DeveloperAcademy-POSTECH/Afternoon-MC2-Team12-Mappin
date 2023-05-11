//
//  ArchiveMusicView.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/09.
//

import SwiftUI

import MusicKit
import ComposableArchitecture

struct ArchiveMusicView: View {
    
    @State var tempButton = false
    let store: StoreOf<MusicReducer>
    @ObservedObject var viewStore: ViewStoreOf<MusicReducer>
    
    init(store: StoreOf<MusicReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if tempButton {
                    archiveEmptyView
                } else {
                    archiveMusicList
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading:
                                    Text("내가 저장한 핀들 돌아보기")
                                        .font(.system(size: 16, weight: .bold)),
                                trailing:
                                    Button(action: {
                                        print("취소 버튼 클릭")
                                    tempButton.toggle()
                                    }, label: {
                                        Text("취소")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(.black)
                                    }))
            .onAppear {
                settingMuesicAuthorization()
            }
            .task {
                viewStore.send(.requestMusicChart)
                // 서버 API 호출
            }
        }
    }
    
    /// 음악 검색 리스트 구현
    var archiveMusicList: some View {
        withAnimation {
            List {
                Section {
                    ForEach(!viewStore.searchTerm.isEmpty ? viewStore.searchMusic : viewStore.musicChart) { music in
                         // selectedMusicIndex == "" -> 초기 상태, 검색했거나 검색창을 켰을 경우. checkmark와 이중 클릭 확인을 하기 위함
                         // 초기 상태, 혹은 유저가 검색을 했을 때. opacity를 주기 위함
                        ArchiveMusicCell(music: music)
                            .onTapGesture {
                        }
                    }
                    // onDelete
                } header: {
                }

            }
            .listStyle(.inset)
        }
    }
    
    var archiveEmptyView: some View {
        Text("아카이브가 비어있어요")
    }
    
    func settingMuesicAuthorization() {
        Task {
            _ = await MusicAuthorization.request()
        }
    }
    
}
