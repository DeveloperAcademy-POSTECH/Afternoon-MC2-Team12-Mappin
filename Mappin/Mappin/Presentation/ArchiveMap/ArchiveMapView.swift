//
//  ArchiveMapView.swift
//  Mappin
//
//  Created by byo on 2023/05/11.
//

import SwiftUI
import ComposableArchitecture

struct ArchiveMapView: View {
    typealias Reducer = ArchiveMapReducer
    typealias MapReducer = PinMusicReducer
    typealias ListReducer = ArchiveMusicReducer
    
    @ObservedObject var viewStore: ViewStoreOf<Reducer>
    
    @StateObject private var mapViewStore: ViewStoreOf<MapReducer> = ViewStore(Store(
        initialState: MapReducer.State(),
        reducer: MapReducer.build()
    ), observe: { $0 })
    
    @StateObject private var listViewStore: ViewStoreOf<ListReducer> = ViewStore(Store(
        initialState: ListReducer.State(),
        reducer: ListReducer.build()
    ), observe: { $0 })
    
    @State private var settingDetents = PresentationDetent.fraction(0.4)
    
    var body: some View {
        Group {
            let isListViewPresented = viewStore.binding(
                get: \.isListViewPresented,
                send: { .setListViewPresented($0) }
            )
            ZStack(alignment: .top) {
                ContentView(viewStore: mapViewStore)
                    .onTapGesture {
                        if mapViewStore.state.detailPin != nil {
                            mapViewStore.send(.popUpClose)
                        }
                    }
                    .gesture(
                        DragGesture()
                          .onEnded { _ in
                              if mapViewStore.state.detailPin != nil {
                                  mapViewStore.send(.popUpClose)
                              }
                          }
                      )
                
                if let pin = mapViewStore.state.detailPin {
                    DetailPinPopUpView(pin: pin)
                        .offset(y: 230)
                }
                FakeNavigationBar()
            }
            .navigationTitle(viewStore.state.category?.navigationTitle ?? "")
            .toolbarTitleMenu {
                ToolbarTitleMenu(viewStore: viewStore)
            }
            .sheet(isPresented: isListViewPresented) {
                ArchiveMusicView(viewStore: listViewStore)
                    .presentationBackgroundInteraction(.enabled)
                    .presentationDetents([.height(viewStore.estimatedListHeight), .fraction(0.12)])
                    .interactiveDismissDisabled()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea()
        .onAppear {
            viewStore.send(.viewAppeared)
        }
        .onChange(of: viewStore.mapAction) {
            guard let action = $0 else { return }
            mapViewStore.send(action)
        }
        .onChange(of: viewStore.listAction) {
            guard let action = $0 else { return }
            listViewStore.send(action)
        }
        .onChange(of: mapViewStore.pinsUsingList) {
            viewStore.send(.setListViewPresented(true))
            listViewStore.send(.applyArchive($0))
        }
        .onChange(of: listViewStore.lastAction) {
            viewStore.send(.receiveList($0?.wrapped))
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
            reducer: ArchiveMapReducer(
                getPinsUseCase: DefaultMockDIContainer.shared.container.resolver.resolve(GetPinsUseCase.self)
            )
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
