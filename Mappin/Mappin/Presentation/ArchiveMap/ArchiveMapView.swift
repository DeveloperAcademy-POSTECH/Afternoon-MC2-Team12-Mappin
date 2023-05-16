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
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewStore: ViewStoreOf<Reducer>
    
    @StateObject private var mapViewStore: ViewStoreOf<MapReducer> = ViewStore(Store(
        initialState: MapReducer.State(),
        reducer: MapReducer.build()
    ), observe: { $0 })
    
    @StateObject private var listViewStore: ViewStoreOf<ListReducer> = ViewStore(Store(
        initialState: ListReducer.State(),
        reducer: ListReducer.build()
    ), observe: { $0 })
    
    private static let foldedPresentationDetent = PresentationDetent.fraction(0.45)
    @State private var presentationDetent = foldedPresentationDetent
    
    var body: some View {
        Group {
            ZStack(alignment: .top) {
                contentView
            }
            .navigationTitle(viewStore.state.category?.navigationTitle ?? "")
            .navigationBarItems(leading: customBackButton)
            .toolbarTitleMenu {
                ToolbarTitleMenu(viewStore: viewStore)
            }
            .navigationBarBackButtonHidden()
        }
        .sheet(isPresented: viewStore.binding(get: \.isListViewPresented,
                                              send: { .setListViewPresented($0) })) {
            ArchiveMusicView(viewStore: listViewStore)
                .presentationBackgroundInteraction(.enabled)
                .presentationDetents(
                    [.fraction(0.45), .fraction(0.71), .large],
                    selection: $presentationDetent
                )
                .interactiveDismissDisabled()
        }
        .sheet(isPresented: mapViewStore.binding(get: { !$0.detailPinIsEmpty },
                                                 send: { .detailPinValidate(!$0) })) {
            if let pin = mapViewStore.detailPin {
//                NavigationView {
                    
//                        .frame(height: 604)
//                        .navigationBarItems(leading: Text("Hi"))
//                }
                ArchiveInfoView(pin: pin)
                    .presentationBackgroundInteraction(.enabled)
                    .presentationDetents([.height(357), .height(604)])
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
        .onChange(of: presentationDetent) {
            viewStore.send(.setListViewFolded($0 == Self.foldedPresentationDetent))
        }
        .onChange(of: viewStore.isListViewFolded) { _ in
            presentationDetent = viewStore.isListViewFolded ? Self.foldedPresentationDetent : .height(viewStore.estimatedListHeight)
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
    
    var customBackButton: some View {
        Button {
            dismiss()
        } label: {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
                Text("홈")
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
    
    @ViewBuilder
    var contentView: some View {
        ContentView(viewStore: mapViewStore)
            .onTapGesture {
                if mapViewStore.state.listPins != nil {
                    mapViewStore.send(.popUpClose)
                }
            }
            .gesture(
                DragGesture()
                  .onEnded { _ in
                      if mapViewStore.state.listPins != nil {
                          mapViewStore.send(.popUpClose)
                      }
                  }
              )
        FakeNavigationBar()
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
