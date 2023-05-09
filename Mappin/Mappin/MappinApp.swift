//
//  MappinApp.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import SwiftUI

@main
struct MappinApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottom) {
                LaunchScreenView.build()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                ToastView.build()
            }
        }
    }
}
