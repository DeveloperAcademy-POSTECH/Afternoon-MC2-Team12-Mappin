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
                    .font(.system(size: 22, weight: .bold))
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
            Spacer()
            Text(viewStore.category?.emptyContent ?? "")
                .multilineTextAlignment(.center)
                .font(.system(size: 15))
                .foregroundColor(Color(red: 0.4235, green: 0.4235, blue: 0.4392))
                .padding(.top, 15)
            Spacer()
        }
        .frame(height: 80)
    }
    
}


private extension PinsCategory {
    var navigationTitle: String {
        navigationSubject + " 저장한 핀들 돌아보기"
    }
    
    var emptyContent: String {
        switch self {
        case .mine:
            return "아직 당신이 저장한 기록이 없습니다.\n당신의 감정을 기록해주세요."
        case .others:
            return "이 주변에 저장된 기록이 없습니다."
        }
    }
    
    private var navigationSubject: String {
        switch self {
        case .mine:
            return "내가"
        case .others:
            return "다른 사람들이"
        }
    }
}
        
extension ArchiveMusicView {
    static func build() -> Self {
        let store = Store(
            initialState: ArchiveMusicReducer.State(),
            reducer: ArchiveMusicReducer(removePinUseCase: DefaultMockDIContainer.shared.container.resolver.resolve(RemovePinUseCase.self)))
        return ArchiveMusicView(viewStore: ViewStore(store))
        
    }
}

