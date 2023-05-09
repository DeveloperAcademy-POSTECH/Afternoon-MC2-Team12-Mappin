//
//  ToastView.swift
//  Mappin
//
//  Created by byo on 2023/05/09.
//

import SwiftUI

struct ToastView: View {
    @ObservedObject var manager: ToastManager
    
    var body: some View {
        Group {
            if let message = manager.currentMessage {
                Text(message)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(.black.opacity(0.7),
                                in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding()
            }
        }
    }
}

extension ToastView {
    static func build() -> Self {
        let manager: ToastManager = .shared
        return ToastView(manager: manager)
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = ToastManager.shared
        return ToastView(manager: manager)
    }
}
