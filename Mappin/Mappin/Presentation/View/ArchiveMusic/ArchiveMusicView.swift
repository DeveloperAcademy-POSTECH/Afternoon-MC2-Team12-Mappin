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
            VStack(spacing: 32) {
                topView
                archiveMusicList
            }
            .padding(.vertical, 32)
            .background(Color(red: 249 / 255, green: 249 / 255, blue: 249 / 255))
            .ignoresSafeArea()
        }
    }
    
    var topView: some View {
        HStack {
            Image(systemName: "location.circle.fill")
                .resizable()
                .foregroundColor(.accentColor)
                .frame(width: 40, height: 40)
            VStack(alignment: .leading, spacing: 4) {
                Text("현재 지도 위에 표시된 핀들")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.black)
                Text("\(viewStore.archiveMusic.count)개의 저장된 핀")
                    .font(.system(size: 13))
                    .foregroundColor(Color(red: 60 / 255, green: 60 / 255, blue: 67 / 255, opacity: 0.6))
            }
            Spacer()
        }
        .padding(.horizontal, 12)
    }
    
    /// 음악 검색 리스트 구현
    var archiveMusicList: some View {
        withAnimation {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(viewStore.archiveMusic) { archive in
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
                .padding(.horizontal, 8)
            }
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

