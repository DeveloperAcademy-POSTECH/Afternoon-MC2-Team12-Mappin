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
                topView
                    .padding(.top, 27)
                if viewStore.state.archiveMusic != nil {
                    archiveMusicList
                } else {
                    archiveEmptyView
                }
            }
        }
    }
    
    var topView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack {
                    Image(systemName: "location.circle.fill")
                        .resizable()
                        .foregroundColor(.accentColor)
                        .frame(width: 32, height: 32)

                }
                .padding(.top, 8)
                .padding(.bottom, 9)
                .padding(.leading, 16)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(viewStore.category?.navigationTitle ?? "")
                        .frame(height: 28)
                        .font(.system(size: 22, weight: .bold))
                        .padding(.bottom, 3)
                    Text("\(viewStore.archiveMusic.count)개의 저장된 핀")
                        .frame(height: 18)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color(red: 0.2353, green: 0.2353, blue: 0.2627).opacity(0.6))
                }
            }
            .padding(.bottom, 18)
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black.opacity(0.3), lineWidth: 0.33)
                .frame(width: 130, height: 33)
                .overlay {
                    Text("가장 최근순 정렬")
                        .font(.system(size: 15, weight: .regular))
                }
                .padding(.leading, 16)
                .padding(.bottom, 10)
            Divider()
                .foregroundColor(Color.blue.opacity(0.3))
        }
    }
    
    /// 음악 검색 리스트 구현
    var archiveMusicList: some View {
        withAnimation {
            List {
                Section {
                    ForEach(viewStore.archiveMusic) { archive in
                        ArchiveMusicCell(music: archive.music, date: archive.createdAt)
                            .listRowInsets(EdgeInsets())
                            .onTapGesture {
                                viewStore.send(.pinTapped(archive))
                            }
                        EmptyView()
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

