//
//  MappinApp.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import SwiftUI
import ComposableArchitecture
import MapKit


@main
struct MappinApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottom) {
                LaunchScreenView.build()
                ToastView.build()
//                Store(
//                    initialState: PinMusicReducer.State(),
//                    reducer: PinMusicReducer(
//                        addPinUseCase: DefaultMockDIContainer.shared.container.resolver.resolve(AddPinUseCase.self),
//                        getPinsUseCase: DefaultMockDIContainer.shared.container.resolver.resolve(GetPinsUseCase.self)
//                    )
//                ArchiveMusicView(store: Store(initialState: ArchiveMusicReducer.State(),
//                                              reducer: ArchiveMusicReducer(removePinUseCase: DefaultMockDIContainer.shared.container.resolver.resolve(RemovePinUseCase.self))))
            }
        }
    }
}
