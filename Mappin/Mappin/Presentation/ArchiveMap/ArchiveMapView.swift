//
//  ArchiveMapView.swift
//  Mappin
//
//  Created by byo on 2023/05/11.
//

import SwiftUI
import ComposableArchitecture

struct ArchiveMapView: View {
    typealias MapReducer = PinMusicReducer
    typealias ListReducer = ArchiveMusicReducer
    
    @ObservedObject var viewStore: ViewStoreOf<ArchiveMapReducer>
    @State var mapViewStore: ViewStoreOf<MapReducer>
    @State var listViewStore: ViewStoreOf<ListReducer>
    
    init(viewStore: ViewStoreOf<ArchiveMapReducer>) {
        self.viewStore = viewStore
        
        self.mapViewStore = ViewStore(Store(
            initialState: MapReducer.State(),
            reducer: MapReducer.build()
        ), observe: { $0 })
        
        self.listViewStore = ViewStore(Store(
            initialState: ListReducer.State(),
            reducer: ListReducer(removePinUseCase: DefaultRemovePinUseCase(pinsRepository: APIPinsRepository()))
        ), observe: { $0 })
    }
    
    var body: some View {
        Group {
            let isListViewPresented = viewStore.binding(
                get: \.isListViewPresented,
                send: { .setListViewPresented($0) }
            )
            ZStack(alignment: .top) {
                ContentView(viewStore: mapViewStore)
                FakeNavigationBar()
            }
            .navigationTitle(viewStore.state.category.navigationTitle)
            .toolbarTitleMenu {
                ToolbarTitleMenu(viewStore: viewStore)
            }
            .sheet(isPresented: isListViewPresented) {
                ArchiveMusicView(viewStore: listViewStore)
            }
            .onAppear {
                viewStore.send(.setListViewPresented(true))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea()
        .onAppear {
            mapViewStore.send(.setCategory(viewStore.category))
            listViewStore.send(.setCategory(viewStore.category))
        }
        .onChange(of: viewStore.mapAction) {
            guard let action = $0 else { return }
            mapViewStore.send(action)
        }
        .onChange(of: viewStore.listAction) {
            guard let action = $0 else { return }
            listViewStore.send(action)
        }
        .onChange(of: mapViewStore.lastAction) {
            guard let action = $0?.wrapped else { return }
            viewStore.send(.receiveMap(action))
        }
        .onChange(of: listViewStore.lastAction) {
            guard let action = $0?.wrapped else { return }
            viewStore.send(.receiveList(action))
        }
    }
    
    private func FakeNavigationBar() -> some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(.ultraThinMaterial)
            Rectangle()
                .fill(.black.opacity(0.3))
                .frame(height: 0.5)
        }
        .frame(height: 96)
    }
    
    private func ToolbarTitleMenu(viewStore: ViewStoreOf<ArchiveMapReducer>) -> some View {
        ForEach(PinsCategory.allCases, id: \.self) { category in
            Button(category.buttonTitle) {
                viewStore.send(.selectCategory(category))
            }
        }
    }
}

extension ArchiveMapView {
    static func build() -> Self {
        ArchiveMapView(viewStore: ViewStore(Store(
            initialState: ArchiveMapReducer.State(),
            reducer: ArchiveMapReducer()
        ), observe: { $0 }))
    }
}

private extension PinsCategory {
    var navigationTitle: String {
        switch self {
        case .mine:
            return "내 핀만"
        case .others:
            return "다른 사람들 핀만"
        }
    }
    
    var buttonTitle: String {
        navigationTitle + " 보기"
    }
}

struct ArchiveMapView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveMapView.build()
    }
}
