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
    
    @ObservedObject var viewStore: ViewStoreOf<ArchiveMusicReducer>
    
    init(viewStore: ViewStoreOf<ArchiveMusicReducer>) {
        self.viewStore = viewStore
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if !viewStore.state.archiveMusic.isEmpty {
                    archiveMusicList
                } else {
                    archiveEmptyView
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(
                leading: Text(viewStore.category?.navigationTitle ?? "")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.top, 16)
            )
        }
    }
    
    /// 음악 검색 리스트 구현
    var archiveMusicList: some View {
        withAnimation {
            List {
                Section {
                    ForEach(viewStore.archiveMusic.isEmpty ? [] : viewStore.archiveMusic) { archive in
                        ArchiveMusicCell(music: archive.music, date: archive.createdAt)
                            .onTapGesture {
                                viewStore.send(.pinTapped(archive))
                            }
                    }
                    .onDelete {
                        viewStore.send(.removeArchive(indexSet: $0))
                    }
                    .deleteDisabled(viewStore.category != .mine)
                }
            }
            .listStyle(.inset)
        }
    }
    
    var archiveEmptyView: some View {
        VStack {
            Text("당신의 감정을 기록해주세요.")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(Color(red: 0.4235, green: 0.4235, blue: 0.4392))
                .padding(.top, 15)
            Button {
                
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 55)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .overlay {
                        Text("현재 위치에 음악 핀하기")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
            }
            Spacer()
        }
    }
    
}

private extension PinsCategory {
    var navigationTitle: String {
        subject + " 저장한 핀들 돌아보기"
    }
    
    private var subject: String {
        switch self {
        case .mine:
            return "내가"
        case .others:
            return "다른 사람들이"
        }
    }
}
