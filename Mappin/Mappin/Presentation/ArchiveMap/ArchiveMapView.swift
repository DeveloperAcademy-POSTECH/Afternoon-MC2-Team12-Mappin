//
//  ArchiveMapView.swift
//  Mappin
//
//  Created by byo on 2023/05/11.
//

import SwiftUI
import ComposableArchitecture

struct ArchiveMapView: View {
    let store: StoreOf<ArchiveMapReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            let isListViewPresented = viewStore.binding(
                get: \.isListViewPresented,
                send: { .setListViewPresented($0) }
            )
            ZStack(alignment: .top) {
                MapView(action: .constant(.none), userTrackingMode: .none)
                FakeNavigationBar()
            }
            .navigationTitle(viewStore.state.category.navigationTitle)
            .toolbarTitleMenu {
                ToolbarTitleMenu(viewStore: viewStore)
            }
            .sheet(isPresented: isListViewPresented) {
                ArchiveView(isPresented: isListViewPresented)
            }
            .onAppear {
                viewStore.send(.setListViewPresented(true))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea()
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
        ForEach(ArchiveMapReducer.Category.allCases, id: \.self) { category in
            Button(category.buttonTitle) {
                viewStore.send(.selectCategory(category))
            }
        }
    }
}

extension ArchiveMapView {
    static func build() -> Self {
        let store = Store(
            initialState: ArchiveMapReducer.State(),
            reducer: ArchiveMapReducer()
        )
        return ArchiveMapView(store: store)
    }
}

struct ArchiveMapView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveMapView.build()
    }
}
